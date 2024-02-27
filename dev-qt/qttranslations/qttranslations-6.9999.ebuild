# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Translation files for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

DEPEND="~dev-qt/qtbase-${PV}:6"
BDEPEND="~dev-qt/qttools-${PV}:6[linguist]"
