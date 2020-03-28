# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit qt5-build

DESCRIPTION="Linux/X11-specific support library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="arm"
fi

IUSE=""

RDEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qtgui-${PV}[xcb]
"
DEPEND="${RDEPEND}
	test? ( ~dev-qt/qtwidgets-${PV} )
"
