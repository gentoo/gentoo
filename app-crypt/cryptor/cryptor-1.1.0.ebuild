# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop meson vala xdg

DESCRIPTION="Simple GUI application for gocryptfs"
HOMEPAGE="https://github.com/moson-mo/cryptor"
SRC_URI="https://github.com/moson-mo/cryptor/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-crypt/gocryptfs
	dev-libs/glib:2
	dev-libs/json-glib
	dev-libs/libgee
	x11-libs/gtk+:3
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	$(vala_depend)
"

DOCS=(README.md)

src_prepare() {
	# The TrayIcon category triggers QA Notice that the "OnlyShowIn" key must be included.
	sed -e 's/TrayIcon;//' -i resources/misc/cryptor.desktop || die
	default
	vala_setup
}

src_install() {
	meson_src_install
	einstalldocs
	domenu resources/misc/cryptor.desktop
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
