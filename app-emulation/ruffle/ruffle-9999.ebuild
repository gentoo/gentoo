# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo desktop flag-o-matic git-r3 virtualx xdg

DESCRIPTION="Flash Player emulator written in Rust"
HOMEPAGE="https://ruffle.rs/"
EGIT_REPO_URI="https://github.com/ruffle-rs/ruffle.git"

LICENSE="Apache-2.0 BSD BSD-2 Boost-1.0 CC0-1.0 ISC MIT MPL-2.0 Unicode-DFS-2016 ZLIB curl"
SLOT="0"

# dlopen: libX* (see winit+x11-dl crates)
RDEPEND="
	dev-libs/glib:2
	dev-libs/openssl:=
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	sys-libs/zlib:=
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXrandr
	x11-libs/libXrender"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="
	virtual/jre:*
	virtual/pkgconfig
	>=virtual/rust-1.64
	test? (
		media-libs/mesa[llvm]
		x11-base/xorg-server[-minimal]
	)"

QA_FLAGS_IGNORED="usr/bin/${PN}.*"

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_compile() {
	filter-lto # does not play well with C code in crates

	cargo_src_compile --bins # note: configure --bins would skip tests
}

src_test() {
	virtx cargo_src_test
}

src_install() {
	dodoc README.md

	newicon web/packages/extension/assets/images/icon180.png ${PN}.png
	make_desktop_entry ${PN} ${PN^} ${PN} "AudioVideo;Player;Emulator;" \
		"MimeType=application/x-shockwave-flash;application/vnd.adobe.flash.movie;"

	cd target/$(usex debug{,} release) || die

	newbin ${PN}_desktop ${PN}
	newbin exporter ${PN}_exporter
	dobin ${PN}_scanner
}
