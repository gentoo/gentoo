# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Translation files for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64"
fi

IUSE=""

DEPEND="=dev-qt/qtbase-${PV}*"
BDEPEND="=dev-qt/qttools-${PV}*[linguist]"
