# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop font readme.gentoo-r1 qmake-utils xdg

MY_PV="0.7.2.rc9i"
MY_P="${PN}"-"${MY_PV}"
DESCRIPTION="Simple and powerful application for creating screenplays."
HOMEPAGE="https://kitscenarist.ru/en/"
SRC_URI="https://github.com/dimkanovikov/KITScenarist/releases/download/"${MY_PV}"/src.tar.gz -> "${MY_P}".tar.gz"
S="${WORKDIR}/src"
DOC_CONTENTS="Quick startup hints at https://kitscenarist.ru/en/help/first_glance.html"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

FONT_SUFFIX="ttf"
FONT_S="${S}/bin/scenarist-core/Resources/Fonts"

DEPEND="dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtmultimedia:5
		dev-qt/qtnetwork:5
		dev-qt/qtpositioning:5
		dev-qt/qtprintsupport:5
		dev-qt/qtquickcontrols:5
		dev-qt/qtsql:5
		dev-qt/qtsvg:5
		dev-qt/qtwebengine:5
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
		sys-libs/zlib[minizip]"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	xdg_src_prepare
}

src_configure() {
	eqmake5 Scenarist.pro
	emake qmake_all
}

src_preinst() {
	xdg_src_prepare
}

src_install() {
	newicon -s 512 bin/scenarist-core/Resources/Icons/logo.png "${PN}".png
	make_desktop_entry "${PN}" "KIT Scenarist" "${PN}" Office
	newbin "${WORKDIR}"/build/Release/bin/scenarist-desktop/Scenarist "${PN}"
	readme.gentoo_create_doc
	font_src_install
}

pkg_postinst() {
	xdg_pkg_postinst
	font_pkg_postinst
	readme.gentoo_print_elog
}

pkg_postrm() {
	xdg_pkg_postrm
	font_pkg_postrm
}
