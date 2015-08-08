# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs autotools

MYPN=ColPack

DESCRIPTION="C++ algorithms for specialized vertex coloring problems"
LICENSE="GPL-3 LGPL-3"
HOMEPAGE="http://www.cscapes.org/coloringpage/software.htm"
SRC_URI="http://www.cscapes.org/download/${MYPN}/${MYPN}-${PV}.tar.gz"

SLOT="0"
IUSE="openmp static-libs"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MYPN}-${PV}"

pkg_setup() {
	if use openmp && [[ $(tc-getCC)$ == *gcc* ]] &&	! tc-has-openmp; then
		ewarn "You are using gcc without OpenMP"
		die "Need an OpenMP capable compiler"
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-flags.patch
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable openmp) \
		$(use_enable static-libs static)
}
