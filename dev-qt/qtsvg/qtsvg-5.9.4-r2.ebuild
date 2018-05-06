# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit qt5-build

DESCRIPTION="SVG rendering library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-fbsd"
fi

IUSE=""

RDEPEND="
	>=dev-qt/qtcore-${PV}-r1:${SLOT}
	~dev-qt/qtgui-${PV}
	>=dev-qt/qtwidgets-${PV}-r1:${SLOT}
	>=sys-libs/zlib-1.2.5
"
DEPEND="${RDEPEND}
	test? ( ~dev-qt/qtxml-${PV} )
"
