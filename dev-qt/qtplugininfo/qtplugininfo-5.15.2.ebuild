# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
QT5_MODULE="qttools"
inherit qt5-build

DESCRIPTION="Qt5 plugin metadata dumper"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~x86"
fi

IUSE=""

DEPEND="
	~dev-qt/qtcore-${PV}
"
RDEPEND="${DEPEND}
	dev-qt/qtchooser
"
