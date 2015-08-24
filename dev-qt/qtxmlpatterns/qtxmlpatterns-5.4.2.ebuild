# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit qt5-build

DESCRIPTION="XPath, XQuery, and XSLT support library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 hppa ~ppc64 ~x86"
fi

IUSE=""

DEPEND="
	>=dev-qt/qtcore-${PV}:5
	>=dev-qt/qtnetwork-${PV}:5
"
RDEPEND="${DEPEND}"
