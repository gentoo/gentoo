# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} != *9999* ]]; then
	QT5_KDEPATCHSET_REV=1
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv x86"
fi

inherit qt5-build

DESCRIPTION="Network authorization library for the Qt5 framework"
LICENSE="GPL-3"

IUSE=""

DEPEND="
	=dev-qt/qtcore-${QT5_PV}*
	=dev-qt/qtnetwork-${QT5_PV}*
"
RDEPEND="${DEPEND}"
