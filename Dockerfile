ARG DEBIAN_DIST=bookworm
FROM debian:trixie

ARG DEBIAN_DIST
ARG YAZI_VERSION
ARG BUILD_VERSION
ARG FULL_VERSION
ARG ARCH
ARG YAZI_RELEASE

RUN mkdir -p /output/usr/bin
RUN mkdir -p /output/usr/share/doc/yazi
COPY ${YAZI_RELEASE}/yazi /output/usr/bin/
COPY ${YAZI_RELEASE}/ya /output/usr/bin/
COPY ${YAZI_RELEASE}/LICENSE /output/usr/bin/
RUN mkdir -p /output/DEBIAN

COPY output/DEBIAN/control /output/DEBIAN/
COPY output/copyright /output/usr/share/doc/yazi/
COPY output/changelog.Debian /output/usr/share/doc/yazi/
COPY output/README.md /output/usr/share/doc/yazi/

RUN sed -i "s/DIST/$DEBIAN_DIST/" /output/usr/share/doc/yazi/changelog.Debian
RUN sed -i "s/FULL_VERSION/$FULL_VERSION/" /output/usr/share/doc/yazi/changelog.Debian
RUN sed -i "s/DIST/$DEBIAN_DIST/" /output/DEBIAN/control
RUN sed -i "s/YAZI_VERSION/$YAZI_VERSION/" /output/DEBIAN/control
RUN sed -i "s/BUILD_VERSION/$BUILD_VERSION/" /output/DEBIAN/control
RUN sed -i "s/SUPPORTED_ARCHITECTURES/$ARCH/" /output/DEBIAN/control

RUN dpkg-deb --build /output /yazi_${FULL_VERSION}.deb


