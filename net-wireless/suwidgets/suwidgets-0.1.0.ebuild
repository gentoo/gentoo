# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit qmake-utils

DESCRIPTION="graphical library containing all SigDigger's custom widgets"
HOMEPAGE="https://github.com/BatchDrake/SuWidgets"
SRC_URI="https://github.com/BatchDrake/SuWidgets/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/SuWidgets-${PV}"

src_configure() {
	eqmake5 SuWidgetsLib.pro
}

src_install() {
	INSTALL_ROOT="${ED}" emake install
}
