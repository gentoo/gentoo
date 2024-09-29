# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo desktop optfeature xdg

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://code.videolan.org/videolan/libplacebo.git"
	inherit git-r3
else
	MY_PV=nightly-${PV:3:4}-${PV:7:2}-${PV:9:2}
	MY_P=${PN}-${MY_PV}
	SRC_URI="
		https://github.com/ruffle-rs/ruffle/archive/refs/tags/${MY_PV}.tar.gz
			-> ${MY_P}.tar.gz
		https://dev.gentoo.org/~ionen/distfiles/${MY_P}-vendor.tar.xz
	"
	S=${WORKDIR}/${MY_P}
	KEYWORDS="~amd64"
fi

DESCRIPTION="Flash Player emulator written in Rust"
HOMEPAGE="https://ruffle.rs/"

LICENSE="|| ( Apache-2.0 MIT )"
LICENSE+="
	Apache-2.0 BSD-2 BSD Boost-1.0 CC0-1.0 ISC UbuntuFontLicense-1.0 MIT
	MPL-2.0 OFL-1.1 openssl Unicode-3.0 Unicode-DFS-2016 ZLIB
" # crates
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

# dlopen: libX* (see winit+x11-dl crates)
RDEPEND="
	media-libs/alsa-lib
	virtual/libudev:=
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXrandr
	x11-libs/libXrender
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	virtual/jre:*
	virtual/pkgconfig
	>=virtual/rust-1.81
"

QA_FLAGS_IGNORED="usr/bin/${PN}.*"

PATCHES=(
	"${FILESDIR}"/${PN}-0_p20231216-skip-render-tests.patch
)

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_configure() {
	local workspaces=(
		ruffle_{desktop,scanner}
		exporter
		$(usev test tests)
	)

	cargo_src_configure "${workspaces[@]/#/--package=}"
}

src_test() {
	local skip=(
		# may need more investigation, strangely "pass" (xfail) when
		# RUSTFLAGS is unset, skip for now (bug #915726)
		--skip from_avmplus/as3/Types/Int/wraparound
	)

	cargo_src_test -- "${skip[@]}"
}

src_install() {
	dodoc README.md

	newicon web/packages/extension/assets/images/icon180.png ${PN}.png
	make_desktop_entry ${PN} ${PN^} ${PN} "AudioVideo;Player;Emulator;" \
		"MimeType=application/x-shockwave-flash;application/vnd.adobe.flash.movie;"

	cd "$(cargo_target_dir)" || die
	newbin ${PN}_desktop ${PN}
	newbin exporter ${PN}_exporter
	dobin ${PN}_scanner
}

pkg_postinst() {
	xdg_pkg_postinst

	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog "${PN} is experimental software that is still under heavy development"
		elog "and only receiving nightly releases. Plans in Gentoo is to update"
		elog "roughly every months if no known major regressions (feel free to"
		elog "report if you feel a newer nightly is needed ahead of time)."
		elog
		elog "There is currently no plans to support wasm builds / browser"
		elog "extensions, this provides the desktop viewer and other tools."
	fi

	optfeature "h264 video decoding" media-libs/openh264
	optfeature "the in-application file picker" sys-apps/xdg-desktop-portal
}
