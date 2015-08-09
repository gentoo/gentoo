# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD=1
AUTOTOOLS_AUTORECONF=1

inherit eutils toolchain-funcs autotools-utils

MYPN=ColPack

DESCRIPTION="C++ algorithms for specialized vertex coloring problems"
LICENSE="GPL-3 LGPL-3"
HOMEPAGE="http://www.cscapes.org/coloringpage/software.htm"
SRC_URI="http://cscapes.cs.purdue.edu/download/${MYPN}/${MYPN}-${PV}.tar.gz"

SLOT="0"
IUSE="openmp static-libs"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MYPN}-${PV}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.6-flags.patch
	"${FILESDIR}"/${PN}-1.0.8-no-bin.patch
	"${FILESDIR}"/${P}-fix_gcc49_omp.patch
)

pkg_setup() {
	if use openmp && [[ $(tc-getCC)$ == *gcc* ]] &&	! tc-has-openmp; then
		ewarn "You are using gcc without OpenMP"
		die "Need an OpenMP capable compiler"
	fi
}

src_configure() {
	local myeconfargs=(	$(use_enable openmp) )
	autotools-utils_src_configure
}
