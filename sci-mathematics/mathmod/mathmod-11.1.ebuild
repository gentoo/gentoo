# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop qmake-utils xdg

DESCRIPTION="Plot parametric and implicit surfaces"
HOMEPAGE="https://github.com/parisolab/mathmod
	https://sourceforge.net/projects/mathmod/
	https://www.facebook.com/parisolab"
SRC_URI="https://github.com/parisolab/mathmod/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5"
DEPEND="${RDEPEND}"

src_configure() {
	eqmake5 MathMod.pro
}

src_install() {
	exeinto /usr/bin
	doexe MathMod
	insinto /usr/share/${P}
	doins mathmodconfig.js mathmodcollection.js advancedmodels.js
	newicon -s 16 images/icon/catenoid_mini_16x16.png catenoid.png
	newicon -s 32 images/icon/catenoid_mini_32x32.png catenoid.png
	newicon -s 64 images/icon/catenoid_mini_64x64.png catenoid.png
	make_desktop_entry MathMod MathMod catenoid
}
