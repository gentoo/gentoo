# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libtecla/libtecla-1.6.2.ebuild,v 1.3 2014/07/25 04:56:28 zerochaos Exp $

EAPI=4

inherit autotools eutils flag-o-matic multilib

DESCRIPTION="Tecla command-line editing library"
HOMEPAGE="http://www.astro.caltech.edu/~mcs/tecla/"
SRC_URI="http://www.astro.caltech.edu/~mcs/tecla/${P}.tar.gz"

LICENSE="icu"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}"

S=${WORKDIR}/libtecla

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-1.6.1-install.patch \
		"${FILESDIR}"/${PN}-1.6.1-ldflags.patch \
		"${FILESDIR}"/${PN}-1.6.1-no-strip.patch \
		"${FILESDIR}"/${PN}-1.6.1-parallel_build2.patch \
		"${FILESDIR}"/${PN}-1.6.1-LDFLAGS2.patch \
		"${FILESDIR}"/${PN}-1.6.1-prll-install.patch
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
		rm -rv "${ED}"/usr/$(get_libdir)/*a || die
}
