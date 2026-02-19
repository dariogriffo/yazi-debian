YAZI_VERSION=$1
BUILD_VERSION=$2
ARCH=${3:-amd64}

if [ -z "$YAZI_VERSION" ] || [ -z "$BUILD_VERSION" ]; then
    echo "Usage: $0 <yazi_version> <build_version> [architecture]"
    echo "Example: $0 25.5.31 1 arm64"
    echo "Example: $0 25.5.31 1 all    # Build for all architectures"
    echo "Supported architectures: amd64, arm64, all"
    exit 1
fi

get_yazi_release() {
    local arch=$1
    case "$arch" in
        "amd64") echo "x86_64" ;;
        "arm64") echo "aarch64" ;;
        *) echo "" ;;
    esac
}

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

    mv yazi-${yazi_release}-unknown-linux-musl/yazi "$yazi_release"
    mv yazi-${yazi_release}-unknown-linux-musl/ya "$yazi_release"
    mv yazi-${yazi_release}-unknown-linux-musl/LICENSE "$yazi_release"

    declare -a arr=("jammy" "noble")

    for dist in "${arr[@]}"; do
        FULL_VERSION="$YAZI_VERSION-${BUILD_VERSION}+${dist}_${build_arch}_ubu"
        echo "  Building $FULL_VERSION"

        if ! docker build . -f Dockerfile.ubu -t "yazi-ubuntu-$dist-$build_arch" \
            --build-arg UBUNTU_DIST="$dist" \
            --build-arg YAZI_VERSION="$YAZI_VERSION" \
            --build-arg BUILD_VERSION="$BUILD_VERSION" \
            --build-arg FULL_VERSION="$FULL_VERSION" \
            --build-arg ARCH="$build_arch" \
            --build-arg YAZI_RELEASE="$yazi_release"; then
            echo "❌ Failed to build Docker image for $dist on $build_arch"
            return 1
        fi

        id="$(docker create "yazi-ubuntu-$dist-$build_arch")"
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

if [ "$ARCH" = "all" ]; then
    echo "🚀 Building yazi $YAZI_VERSION-$BUILD_VERSION for all supported Ubuntu architectures..."
    echo ""
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
    if ! build_architecture "$ARCH"; then
        exit 1
    fi
fi
