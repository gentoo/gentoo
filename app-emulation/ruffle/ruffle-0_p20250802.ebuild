# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER=1.86.0
inherit cargo desktop optfeature xdg

MY_PV=nightly-${PV:3:4}-${PV:7:2}-${PV:9:2}
MY_P=${PN}-${MY_PV}

DESCRIPTION="Flash Player emulator written in Rust"
HOMEPAGE="https://ruffle.rs/"
SRC_URI="
	https://github.com/ruffle-rs/ruffle/archive/refs/tags/${MY_PV}.tar.gz
		-> ${MY_P}.tar.gz
	https://dev.gentoo.org/~ionen/distfiles/${MY_P}-vendor.tar.xz
"
S=${WORKDIR}/${MY_P}

LICENSE="|| ( Apache-2.0 MIT )"
LICENSE+="
	Apache-2.0 BSD-2 BSD CC0-1.0 CDLA-Permissive-2.0 ISC MIT MPL-2.0
	OFL-1.1 openssl UbuntuFontLicense-1.0 Unicode-3.0 ZLIB BZIP2
" # crates
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

# X/wayland are dlopen'ed optfeatures, not needed at build time
RDEPEND="
	media-libs/alsa-lib
	virtual/libudev:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/jre:*
	virtual/pkgconfig
"

QA_FLAGS_IGNORED="usr/bin/${PN}.*"

PATCHES=(
	"${FILESDIR}"/${PN}-0_p20231216-skip-render-tests.patch
)

src_configure() {
	local workspaces=(
		ruffle_{desktop,scanner}
		exporter
		$(usev test tests)
	)

	cargo_src_configure "${workspaces[@]/#/--package=}"
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
		elog "roughly every two months if no known major regressions (feel free"
		elog "to report if you feel a newer nightly is needed ahead of time)."
		elog
		elog "There is currently no plans to support wasm builds / browser"
		elog "extensions, this provides the desktop viewer and other tools."
	fi

	optfeature "h264 video decoding" media-libs/openh264
	optfeature "the in-application file picker" sys-apps/xdg-desktop-portal
}
