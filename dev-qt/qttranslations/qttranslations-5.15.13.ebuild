# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

inherit qt5-build

DESCRIPTION="Translation files for the Qt5 framework"

IUSE=""

DEPEND="=dev-qt/qtcore-${QT5_PV}*"
BDEPEND="=dev-qt/linguist-tools-${QT5_PV}*"
