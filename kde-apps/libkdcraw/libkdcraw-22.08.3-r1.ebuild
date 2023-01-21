# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=5.15.5
inherit ecm gear.kde.org

DESCRIPTION="Digital camera raw image library wrapper"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv x86"
IUSE=""

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=media-libs/libraw-0.16:=
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-22.12.0-libraw-0.21.patch ) # bug 887355
