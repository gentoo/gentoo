# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
QT5_MODULE_EXAMPLES_SUBDIRS=("examples")
inherit qt5-build

DESCRIPTION="Set of next generation Qt Quick controls for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~x86"
fi

IUSE=""

DEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qtdeclarative-${PV}
	~dev-qt/qtgraphicaleffects-${PV}
	~dev-qt/qtgui-${PV}
"
RDEPEND="${DEPEND}"
