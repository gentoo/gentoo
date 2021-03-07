# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_EXAMPLES="true"
ECM_QTHELP="true"
ECM_TEST="true"
KDE_ORG_CATEGORY="graphics"
QTMIN=5.15.1
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Powerful libraries (KChart, KGantt) for creating business diagrams"
HOMEPAGE="https://api.kde.org/kdiagram/index.html
https://www.kdab.com/development-resources/qt-tools/kd-chart/"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 arm64 ~ppc64 x86"
fi

LICENSE="GPL-2" # TODO CHECK
SLOT="5"

REQUIRED_USE="test? ( examples )"

BDEPEND="
	>=dev-qt/linguist-tools-${QTMIN}:5
"
DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
"
RDEPEND="${DEPEND}"
