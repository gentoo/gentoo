# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="OffiX' Drag'n'drop library"
HOMEPAGE="http://leb.net/offix"
SRC_URI="http://leb.net/offix/${PN}.${PV}.tgz"
S="${WORKDIR}/DND/DNDlib"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86"

RDEPEND="
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXmu
	x11-libs/libXt"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.diff
	"${FILESDIR}"/Makefile-fix.patch
)

DOCS=(
	# README is useless
	CHANGELOG
)

src_configure() {
	tc-export CC CXX RANLIB AR
	econf --with-x
}
