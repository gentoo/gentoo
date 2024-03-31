# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt5-build

DESCRIPTION="Module for displaying web content in a QML application using the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

IUSE=""

DEPEND="
	=dev-qt/qtcore-${QT5_PV}*
	=dev-qt/qtdeclarative-${QT5_PV}*
	=dev-qt/qtgui-${QT5_PV}*
	=dev-qt/qtwebengine-${QT5_PV}*:5
"
RDEPEND="${DEPEND}"
