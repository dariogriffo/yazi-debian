ARG DEBIAN_DIST=bookworm
FROM buildpack-deps:$DEBIAN_DIST

ARG DEBIAN_DIST
ARG yazi_VERSION
ARG BUILD_VERSION
ARG FULL_VERSION

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=1.85.0

RUN set -eux; \
    wget "https://static.rust-lang.org/rustup/archive/1.28.1/x86_64-unknown-linux-gnu/rustup-init"; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --profile minimal --default-toolchain 1.85.0 --default-host x86_64-unknown-linux-gnu;

RUN mkdir -p /output/usr/bin
RUN mkdir -p /output/usr/share/doc/yazi
RUN git clone https://github.com/sxyazi/yazi.git
RUN cd yazi && cargo build --release --all-features && cp ./target/release/yazi /output/usr/bin/
RUN mkdir -p /output/DEBIAN

COPY output/DEBIAN/control /output/DEBIAN/
COPY output/copyright /output/usr/share/doc/yazi/
COPY output/changelog.Debian /output/usr/share/doc/yazi/
COPY output/README.md /output/usr/share/doc/yazi/

RUN sed -i "s/DIST/$DEBIAN_DIST/" /output/usr/share/doc/yazi/changelog.Debian
RUN sed -i "s/FULL_VERSION/$FULL_VERSION/" /output/usr/share/doc/yazi/changelog.Debian
RUN sed -i "s/DIST/$DEBIAN_DIST/" /output/DEBIAN/control
RUN sed -i "s/yazi_VERSION/$yazi_VERSION/" /output/DEBIAN/control
RUN sed -i "s/BUILD_VERSION/$BUILD_VERSION/" /output/DEBIAN/control

RUN dpkg-deb --build /output /yazi_${FULL_VERSION}.deb
