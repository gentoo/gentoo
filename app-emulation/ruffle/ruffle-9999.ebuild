# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# python is needed by xcb-0.8.2 until update to >=0.10
PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE="xml(+)"
inherit cargo desktop flag-o-matic git-r3 python-any-r1 xdg

DESCRIPTION="Flash Player emulator written in Rust"
HOMEPAGE="https://ruffle.rs/"
EGIT_REPO_URI="https://github.com/ruffle-rs/ruffle.git"

LICENSE="Apache-2.0 BSD BSD-2 CC0-1.0 ISC MIT MPL-2.0 Unicode-DFS-2016 ZLIB curl"
SLOT="0"

RDEPEND="
	dev-libs/glib:2
	dev-libs/openssl:=
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	sys-libs/zlib:=
	x11-libs/gtk+:3
	x11-libs/libxcb:="
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	virtual/jre:*
	virtual/pkgconfig
	>=virtual/rust-1.64"

QA_FLAGS_IGNORED="
	usr/bin/${PN}
	usr/bin/${PN}_exporter
	usr/bin/${PN}_scanner"

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_compile() {
	filter-lto # does not play well with C code in crates

	cargo_src_compile --bins # note: configure --bins would skip tests
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
