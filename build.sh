yazi_VERSION=$1
BUILD_VERSION=$2
declare -a arr=("bookworm" "trixie" "forky" "sid")
for i in "${arr[@]}"
do
  DEBIAN_DIST=$i
  FULL_VERSION=$yazi_VERSION-${BUILD_VERSION}+${DEBIAN_DIST}_amd64
docker build . -t yazi-$DEBIAN_DIST  --build-arg DEBIAN_DIST=$DEBIAN_DIST --build-arg yazi_VERSION=$yazi_VERSION --build-arg BUILD_VERSION=$BUILD_VERSION --build-arg FULL_VERSION=$FULL_VERSION
  id="$(docker create yazi-$DEBIAN_DIST)"
  docker cp $id:/yazi_$FULL_VERSION.deb - > ./yazi_$FULL_VERSION.deb
  tar -xf ./yazi_$FULL_VERSION.deb
done


