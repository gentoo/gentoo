# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils ltprune

DESCRIPTION="A Comprehensive Open Source Library for Galois Field Arithmetic"
HOMEPAGE="http://jerasure.org/"
SRC_URI="https://dev.gentoo.org/~prometheanfire/dist/${P}.tar.gz"
S="${WORKDIR}/${PN}.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e 's/ -O3 $(SIMD_FLAGS)//g' src/Makefile.am tools/Makefile.am test/Makefile.am examples/Makefile.am|| die
	eautoreconf
}

src_install() {
	default
	prune_libtool_files
}
