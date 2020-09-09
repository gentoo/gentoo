# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qt5-build

DESCRIPTION="Qt module for keyframe-based timeline construction"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~x86"
fi

DEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qtdeclarative-${PV}
"
RDEPEND="${DEPEND}"
