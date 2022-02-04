# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# python is needed by xcb-0.8.2 until update to >=0.10
PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="xml(+)"
inherit cargo desktop flag-o-matic git-r3 python-any-r1 xdg

DESCRIPTION="Flash Player emulator written in Rust"
HOMEPAGE="https://ruffle.rs/"
EGIT_REPO_URI="https://github.com/ruffle-rs/ruffle.git"

LICENSE="Apache-2.0 BSD BSD-2 CC0-1.0 ISC MIT MPL-2.0 ZLIB curl zlib-acknowledgement"
SLOT="0"
IUSE="gui"

DEPEND="
	dev-libs/openssl:=
	media-libs/alsa-lib
	sys-libs/zlib:=
	x11-libs/libxcb:="
RDEPEND="
	${DEPEND}
	gui? (
		|| (
			gnome-extra/zenity
			kde-apps/kdialog
		)
	)"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
	>=virtual/rust-1.56"

QA_FLAGS_IGNORED="
	usr/bin/${PN}
	usr/bin/${PN}_exporter
	usr/bin/${PN}_scanner"

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_compile() {
	filter-flags '-flto*' # undefined references with tinyfiledialogs and more

	cargo_src_compile --bins # note: configure --bins would skip tests
}

src_install() {
	dodoc README.md

	# does not have a real GUI yet, flag is used to ensure there is a
	# way for messages and file picker to be displayed with .desktop
	if use gui; then
		newicon web/packages/extension/assets/images/icon180.png ${PN}.png
		make_desktop_entry ${PN} ${PN^} ${PN} "AudioVideo;Player;Emulator;" \
			"MimeType=application/x-shockwave-flash;application/vnd.adobe.flash.movie;"
	fi

	cd target/$(usex debug{,} release) || die

	newbin ${PN}_desktop ${PN}
	newbin exporter ${PN}_exporter
	dobin ${PN}_scanner
}
