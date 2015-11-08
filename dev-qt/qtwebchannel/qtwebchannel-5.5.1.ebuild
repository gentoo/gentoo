# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit qt5-build

DESCRIPTION="Qt5 framework module for integrating C++ and QML applications with HTML/JavaScript clients"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~x86"
fi

IUSE="qml"

DEPEND="
	>=dev-qt/qtcore-${PV}:5
	qml? ( >=dev-qt/qtdeclarative-${PV}:5 )
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-optional-qtdeclarative.patch" )

src_prepare() {
	qt_use_disable_mod qml quick src/src.pro
	qt_use_disable_mod qml qml src/webchannel/webchannel.pro

	qt5-build_src_prepare
}
