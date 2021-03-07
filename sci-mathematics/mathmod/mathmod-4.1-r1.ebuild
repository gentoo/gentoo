# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop qmake-utils xdg-utils

DESCRIPTION="Plot parametric and implicit surfaces"
HOMEPAGE="https://www.facebook.com/pages/MathMod/529510253833102"
SRC_URI="mirror://sourceforge/${PN}/${P}.src.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${PN}-branches-274-trunk

src_configure() {
	eqmake5 MathMod.pro
}

src_install() {
	exeinto /usr/bin
	doexe MathMod
	insinto /usr/share/${P}
	doins mathmodconfig.js mathmodcollection.js advancedmodels.js
	newicon -s 16 icon/catenoid_mini_16x16.png catenoid.png
	newicon -s 32 icon/catenoid_mini_32x32.png catenoid.png
	newicon -s 64 icon/catenoid_mini_64x64.png catenoid.png
	make_desktop_entry MathMod MathMod catenoid
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
