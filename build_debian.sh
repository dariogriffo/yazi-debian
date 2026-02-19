YAZI_VERSION=$1
BUILD_VERSION=$2
ARCH=${3:-amd64}  # Default to amd64 if no architecture specified

if [ -z "$YAZI_VERSION" ] || [ -z "$BUILD_VERSION" ]; then
    echo "Usage: $0 <yazi_version> <build_version> [architecture]"
    echo "Example: $0 25.5.31 1 arm64"
    echo "Example: $0 25.5.31 1 all    # Build for all architectures"
    echo "Supported architectures: amd64, arm64, all"
    exit 1
fi

# Function to map Debian architecture to yazi release name
get_yazi_release() {
    local arch=$1
    case "$arch" in
        "amd64")
            echo "x86_64"
            ;;
        "arm64")
            echo "aarch64"
            ;;
        *)
            echo ""
            ;;
    esac
}

# Function to build for a specific architecture
build_architecture() {
    local build_arch=$1
    local yazi_release

    yazi_release=$(get_yazi_release "$build_arch")
    if [ -z "$yazi_release" ]; then
        echo "❌ Unsupported architecture: $build_arch"
        echo "Supported architectures: amd64, arm64"
        return 1
    fi

    echo "Building for architecture: $build_arch using $yazi_release"
    
    rm -rf $yazi_release || true
    rm -f "yazi-${build_arch}-unknown-linux-musl.zip" || true
    
    # Download and extract yazi binary for this architecture
        if ! wget "https://github.com/sxyazi/yazi/releases/download/v${YAZI_VERSION}/yazi-${yazi_release}-unknown-linux-musl.zip"; then
            echo "❌ Failed to download yazi binary for $build_arch"
            return 1
        fi
    
        # Create directory and extract zip file
        mkdir -p "$yazi_release"
        if ! unzip "yazi-${yazi_release}-unknown-linux-musl.zip"; then
            echo "❌ Failed to extract yazi binary for $yazi_release"
            return 1
        fi
        
        mv yazi-${yazi_release}-unknown-linux-musl/yazi "$yazi_release"
        mv yazi-${yazi_release}-unknown-linux-musl/ya "$yazi_release"
        mv yazi-${yazi_release}-unknown-linux-musl/LICENSE "$yazi_release"
        

    # Build packages for all Debian distributions
    declare -a arr=("bookworm" "trixie" "forky" "sid")

    for dist in "${arr[@]}"; do
        FULL_VERSION="$YAZI_VERSION-${BUILD_VERSION}+${dist}_${build_arch}"
        echo "  Building $FULL_VERSION"

        if ! docker build . -t "yazi-$dist-$build_arch" \
            --build-arg DEBIAN_DIST="$dist" \
            --build-arg YAZI_VERSION="$YAZI_VERSION" \
            --build-arg BUILD_VERSION="$BUILD_VERSION" \
            --build-arg FULL_VERSION="$FULL_VERSION" \
            --build-arg ARCH="$build_arch" \
            --build-arg YAZI_RELEASE="$yazi_release"; then
            echo "❌ Failed to build Docker image for $dist on $build_arch"
            return 1
        fi

        id="$(docker create "yazi-$dist-$build_arch")"
        if ! docker cp "$id:/yazi_$FULL_VERSION.deb" - > "./yazi_$FULL_VERSION.deb"; then
            echo "❌ Failed to extract .deb package for $dist on $build_arch"
            return 1
        fi

        if ! tar -xf "./yazi_$FULL_VERSION.deb"; then
            echo "❌ Failed to extract .deb contents for $dist on $build_arch"
            return 1
        fi
    done

    echo "✅ Successfully built for $build_arch"
    return 0
}

# Main build logic
if [ "$ARCH" = "all" ]; then
    echo "🚀 Building yazi $YAZI_VERSION-$BUILD_VERSION for all supported architectures..."
    echo ""

    # All supported architectures
    ARCHITECTURES=("amd64" "arm64")

    for build_arch in "${ARCHITECTURES[@]}"; do
        echo "==========================================="
        echo "Building for architecture: $build_arch"
        echo "==========================================="

        if ! build_architecture "$build_arch"; then
            echo "❌ Failed to build for $build_arch"
            exit 1
        fi

        echo ""
    done

    echo "🎉 All architectures built successfully!"
    echo "Generated packages:"
    ls -la yazi_*.deb
else
    # Build for single architecture
    if ! build_architecture "$ARCH"; then
        exit 1
    fi
fi


