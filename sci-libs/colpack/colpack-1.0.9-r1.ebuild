# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools toolchain-funcs

MY_PN="ColPack"

DESCRIPTION="C++ algorithms for specialized vertex coloring problems"
LICENSE="GPL-3 LGPL-3"
HOMEPAGE="http://www.cscapes.org/coloringpage/software.htm"
SRC_URI="http://cscapes.cs.purdue.edu/download/${MY_PN}/${MY_PN}-${PV}.tar.gz"

SLOT="0"
IUSE="openmp static-libs"
KEYWORDS="~alpha ~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"

PATCHES=(
	"${FILESDIR}/${PN}-1.0.6-flags.patch"
	"${FILESDIR}/${PN}-1.0.8-no-bin.patch"
	"${FILESDIR}/${PN}-1.0.9-fix_gcc49_omp.patch"
	"${FILESDIR}/${PN}-1.0.9-fix-c++14.patch"
)

pkg_setup() {
	if use openmp && [[ $(tc-getCC)$ == *gcc* ]] &&	! tc-has-openmp; then
		ewarn "You are using gcc without OpenMP"
		die "Need an OpenMP capable compiler"
	fi
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--enable-shared \
		$(use_enable static-libs static) \
		$(use_enable openmp)
}

src_install() {
	default

	if ! use static-libs; then
		find "${D}" -name '*.la' -delete || die
	fi
}
