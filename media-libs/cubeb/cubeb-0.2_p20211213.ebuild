# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CARGO_OPTIONAL=1
CRATES="
	bitflags-1.3.2
	cache-padded-1.2.0
	cc-1.0.72
	cmake-0.1.46
	cubeb-backend-0.9.0
	cubeb-core-0.9.0
	cubeb-sys-0.9.1
	libc-0.2.112
	pkg-config-0.3.24
	ringbuf-0.2.6
	semver-0.9.0
	semver-parser-0.7.0"
inherit cargo cmake

CUBEB_COMMIT="773f16b7ea308392c05be3e290163d1f636e6024"
PULSERS_COMMIT="f2456201dbfdc467b80f0ff6bbb1b8a6faf7df02"

DESCRIPTION="Cross-platform audio library"
HOMEPAGE="https://github.com/mozilla/cubeb/"
SRC_URI="
	https://github.com/mozilla/cubeb/archive/${CUBEB_COMMIT}.tar.gz -> ${P}.tar.gz
	pulseaudio? ( rust? (
		https://github.com/mozilla/cubeb-pulse-rs/archive/${PULSERS_COMMIT}.tar.gz -> ${PN}-pulse-rs-${PV}.tar.gz
		$(cargo_crate_uris)
	) )"
S="${WORKDIR}/${PN}-${CUBEB_COMMIT}"

LICENSE="ISC pulseaudio? ( rust? ( || ( Apache-2.0 MIT ) ) )"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"
IUSE="alsa doc jack pulseaudio +rust sndio test"
RESTRICT="!test? ( test )"

RDEPEND="
	media-libs/speexdsp
	alsa? ( media-libs/alsa-lib )
	jack? ( virtual/jack )
	pulseaudio? ( media-sound/pulseaudio )
	sndio? ( media-sound/sndio:= )"
DEPEND="
	${RDEPEND}
	test? ( dev-cpp/gtest )"
BDEPEND="
	doc? ( app-doc/doxygen )
	pulseaudio? ( rust? ( ${RUST_DEPEND} ) )"

PATCHES=(
	"${FILESDIR}"/${P}-automagic.patch
)

src_unpack() {
	use pulseaudio && use rust && cargo_src_unpack || default
}

src_prepare() {
	if use pulseaudio && use rust; then
		mv ../${PN}-pulse-rs-${PULSERS_COMMIT} src/${PN}-pulse-rs || die
	fi

	cmake_src_prepare

	use !debug || sed -i 's|/release/|/debug/|' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_RUST_LIBS=$(usex rust)
		-DBUILD_TESTS=$(usex test)
		-DCHECK_ALSA=$(usex alsa)
		-DCHECK_JACK=$(usex jack)
		-DCHECK_PULSE=$(usex pulseaudio)
		-DCHECK_SNDIO=$(usex sndio)
		-DLAZY_LOAD_LIBS=no
		-DUSE_SANITIZERS=no
		$(cmake_use_find_package doc Doxygen)
	)

	use pulseaudio && use rust &&
		cargo_src_configure --manifest-path src/${PN}-pulse-rs/Cargo.toml

	cmake_src_configure
}

src_compile() {
	use pulseaudio && use rust && cargo_src_compile

	cmake_src_compile
}

src_test() {
	use pulseaudio && use rust && cargo_src_test

	# these tests need access to audio devices and no sandbox
	cmake_src_test -E '(audio|callback_ret|device_changed_callback|devices|duplex|latency|record|sanity|tone)'
}

src_install() {
	cmake_src_install

	use doc && dodoc -r "${BUILD_DIR}"/docs/html

	use !test || rm "${ED}"/usr/bin/test_* || die
}
