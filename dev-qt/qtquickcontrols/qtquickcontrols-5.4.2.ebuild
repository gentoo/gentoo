# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit qt5-build

DESCRIPTION="Set of controls used in conjunction with Qt Quick to build complete interfaces"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc64 ~x86"
fi

IUSE="+widgets"

DEPEND="
	>=dev-qt/qtcore-${PV}:5
	>=dev-qt/qtdeclarative-${PV}:5
	>=dev-qt/qtgui-${PV}:5
	widgets? ( >=dev-qt/qtwidgets-${PV}:5 )
"
RDEPEND="${DEPEND}"

src_prepare() {
	qt_use_disable_mod widgets widgets \
		src/src.pro \
		src/controls/Private/private.pri \
		tests/auto/activeFocusOnTab/activeFocusOnTab.pro \
		tests/auto/controls/controls.pro \
		tests/auto/testplugin/testplugin.pro

	qt5-build_src_prepare
}
