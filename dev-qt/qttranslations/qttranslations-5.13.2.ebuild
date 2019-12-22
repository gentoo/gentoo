# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit qt5-build

DESCRIPTION="Translation files for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm arm64 ~hppa ~ppc ppc64 ~sparc ~x86"
fi

IUSE=""

DEPEND="
	~dev-qt/linguist-tools-${PV}
	~dev-qt/qtcore-${PV}
"
RDEPEND=""
