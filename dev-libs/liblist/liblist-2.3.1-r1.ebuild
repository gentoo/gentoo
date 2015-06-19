# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/liblist/liblist-2.3.1-r1.ebuild,v 1.5 2011/03/11 14:07:26 tomka Exp $

EAPI=3

inherit multilib

DESCRIPTION="This package provides generic linked-list manipulation routines, plus queues and stacks"
HOMEPAGE="http://ohnopub.net/liblist"
SRC_URI="ftp://ohnopublishing.net/mirror/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux"
IUSE="doc examples static-libs"

DEPEND="doc? ( media-gfx/transfig
	dev-texlive/texlive-metapost
	virtual/latex-base )"

src_configure() {
	econf --docdir="${EPREFIX}"/usr/share/doc/${PF} \
		$(use_enable doc docs) \
		$(use_enable examples) \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc README || die

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/{*.c,Makefile,README} || die
		insinto /usr/share/doc/${PF}/examples/cache
		doins examples/cache/{*.c,README} || die
	fi

	if ! use static-libs; then
		rm -v "${ED}"/usr/$(get_libdir)/liblist.la || die
		if use examples; then
			rm -v "${ED}"/usr/$(get_libdir)/libcache.la || die
		fi
	fi
}

pkg_postinst() {
	elog "Note the man pages for this package have been renamed to avoid"
	elog "name collisions with some system functions, however, the libs"
	elog "and header files have not been changed."
	elog "The new names are llist, lcache, lqueue, and lstack."
}
