# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT5_KDEPATCHSET_REV=2
QT5_MODULE="qtbase"
inherit qt5-build

DESCRIPTION="Multi-threading concurrence support library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~sparc x86"
fi

IUSE=""

DEPEND="=dev-qt/qtcore-${QT5_PV}*:5="
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/concurrent
)

PATCHES=( "${FILESDIR}/${P}-fix-race-conditions.patch" ) # kde/5.15 branch
