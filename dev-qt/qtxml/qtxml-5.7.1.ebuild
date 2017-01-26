# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
QT5_MODULE="qtbase"
inherit qt5-build

DESCRIPTION="Implementation of SAX and DOM for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
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
