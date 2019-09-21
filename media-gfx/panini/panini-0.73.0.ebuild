# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop qmake-utils xdg-utils

MY_P="${P/p/P}-src"
DESCRIPTION="OpenGL-based panoramic image viewer"
HOMEPAGE="https://github.com/lazarus-pkgs/panini"
SRC_URI="https://github.com/lazarus-pkgs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5
	sys-libs/zlib
	virtual/glu
"
DEPEND="${RDEPEND}
	app-arch/unzip
"

DOCS=( NEWS {BUILD,README,USAGE}.md )

src_prepare() {
	default
	eqmake5 ${PN}.pro
}

src_install() {
	einstalldocs
	dobin panini
	domenu "${FILESDIR}"/${PN}.desktop
	newicon ui/panini-icon-blue.jpg ${PN}.jpg
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
