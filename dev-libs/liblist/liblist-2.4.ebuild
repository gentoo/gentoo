# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools-utils multilib

DESCRIPTION="This package provides generic linked-list manipulation routines, plus queues and stacks"
HOMEPAGE="http://ohnopub.net/liblist"
SRC_URI="ftp://ohnopublishing.net/mirror/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux"
IUSE="doc examples static-libs"

RDEPEND="doc? ( media-gfx/transfig
		dev-texlive/texlive-metapost
		virtual/latex-base )"
DEPEND="${RDEPEND}"

src_configure() {
	local myeconfargs=(
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		$(use_enable doc docs)
		$(use_enable examples)
	)

	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	dodoc README

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/{*.c,Makefile,README}
		insinto /usr/share/doc/${PF}/examples/cache
		doins examples/cache/{*.c,README}
	fi

	docompress -x /usr/share/doc/${PF}/{list.0,paper.dvi,examples}
}

pkg_postinst() {
	elog "Note that man pages for this package have been renamed to avoid"
	elog "name collisions with some system functions. However, the libs"
	elog "and header files have not been changed."
	elog "The new names are liblist, lcache, liblist_queue, and liblist_stack."
}
