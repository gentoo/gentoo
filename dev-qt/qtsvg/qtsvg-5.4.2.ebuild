# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-qt/qtsvg/qtsvg-5.4.2.ebuild,v 1.1 2015/06/17 15:23:20 pesa Exp $

EAPI=5
inherit qt5-build

DESCRIPTION="SVG rendering library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc64 ~x86"
fi

IUSE=""

RDEPEND="
	>=dev-qt/qtcore-${PV}:5
	>=dev-qt/qtgui-${PV}:5
	>=dev-qt/qtwidgets-${PV}:5
	>=sys-libs/zlib-1.2.5
"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qtxml-${PV}:5 )
"
