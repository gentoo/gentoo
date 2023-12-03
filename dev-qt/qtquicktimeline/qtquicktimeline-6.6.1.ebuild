# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Qt module for keyframe-based timeline construction"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv"
fi

RDEPEND="
	~dev-qt/qtbase-${PV}:6
	~dev-qt/qtdeclarative-${PV}:6
"
DEPEND="${RDEPEND}"
