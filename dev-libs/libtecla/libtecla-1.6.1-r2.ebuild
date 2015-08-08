# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools eutils flag-o-matic multilib

DESCRIPTION="Tecla command-line editing library"
HOMEPAGE="http://www.astro.caltech.edu/~mcs/tecla/"
SRC_URI="http://www.astro.caltech.edu/~mcs/tecla/${P}.tar.gz"

LICENSE="icu"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86"
IUSE="static-libs"

DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}"

S=${WORKDIR}/libtecla

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-install.patch \
		"${FILESDIR}"/${P}-ldflags.patch \
		"${FILESDIR}"/${P}-no-strip.patch \
		"${FILESDIR}"/${P}-parallel_build2.patch \
		"${FILESDIR}"/${P}-LDFLAGS2.patch \
		"${FILESDIR}"/${P}-prll-install.patch
	eautoreconf
}

src_compile() {
	emake \
		OPT="" \
		LDFLAGS="${LDFLAGS}" \
		LFLAGS="$(raw-ldflags)"
}

src_install() {
	default
	use static-libs || \
		rm -rvf "${ED}"/usr/$(get_libdir)/*a || die
}
