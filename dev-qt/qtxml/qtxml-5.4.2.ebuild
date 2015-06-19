# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-qt/qtxml/qtxml-5.4.2.ebuild,v 1.1 2015/06/17 15:24:32 pesa Exp $

EAPI=5
QT5_MODULE="qtbase"
inherit qt5-build

DESCRIPTION="SAX and DOM implementation library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc64 ~x86"
fi

IUSE=""

RDEPEND="
	~dev-qt/qtcore-${PV}
"
DEPEND="${RDEPEND}
	test? ( ~dev-qt/qtnetwork-${PV} )
"

QT5_TARGET_SUBDIRS=(
	src/xml
)
