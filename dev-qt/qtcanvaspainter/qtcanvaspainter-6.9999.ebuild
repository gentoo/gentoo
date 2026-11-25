# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Accelerated 2D painting solution for Qt Quick and QRhi-based render targets"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64"
fi

RDEPEND="
	~dev-qt/qtbase-${PV}:6[gui,widgets]
	~dev-qt/qtdeclarative-${PV}:6
"
DEPEND="${RDEPEND}"
BDEPEND="
	~dev-qt/qtshadertools-${PV}
"
