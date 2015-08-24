# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit qt5-build

DESCRIPTION="Translation files for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm hppa ~ppc64 ~x86"
fi

IUSE=""

DEPEND="
	>=dev-qt/linguist-tools-${PV}:5
	>=dev-qt/qtcore-${PV}:5
"
RDEPEND=""
