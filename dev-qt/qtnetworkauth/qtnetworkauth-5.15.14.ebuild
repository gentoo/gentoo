# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PATCHSET="${PN}-5.15.14-gentoo-kde-1"
inherit qt5-build

DESCRIPTION="Network authorization library for the Qt5 framework"
LICENSE="GPL-3"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	SRC_URI+=" https://dev.gentoo.org/~asturm/distfiles/${PATCHSET}.tar.xz"
	KEYWORDS="amd64 arm64 ~ppc64 ~riscv x86"
fi

IUSE=""

DEPEND="
	=dev-qt/qtcore-${QT5_PV}*
	=dev-qt/qtnetwork-${QT5_PV}*
"
RDEPEND="${DEPEND}"

if [[ ${QT5_BUILD_TYPE} == release ]]; then

	PATCHES=( "${WORKDIR}/${PATCHSET}" )

fi
