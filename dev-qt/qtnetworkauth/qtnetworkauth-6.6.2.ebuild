# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Network authorization library for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64"
fi

RDEPEND="~dev-qt/qtbase-${PV}:6[network]"
DEPEND="${RDEPEND}"
