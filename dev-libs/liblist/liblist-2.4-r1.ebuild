# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Generic linked-list manipulation routines, plus queues and stacks"
HOMEPAGE="http://ohnopub.net/liblist"
SRC_URI="ftp://ohnopublishing.net/mirror/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux"
IUSE="doc examples"

BDEPEND="
	doc? (
		dev-texlive/texlive-metapost
		media-gfx/transfig
		virtual/latex-base
	)
"

src_configure() {
	econf \
		--disable-static \
		$(use_enable doc docs) \
		$(use_enable examples)
}

src_install() {
	default

	if use examples; then
		docinto examples
		dodoc examples/{*.c,Makefile,README}
		docinto examples/cache
		dodoc examples/cache/{*.c,README}
	fi

	docompress -x /usr/share/doc/${PF}/{list.0,paper.dvi,examples}

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	elog "Note that man pages for this package have been renamed to avoid"
	elog "name collisions with some system functions. However, the libs"
	elog "and header files have not been changed."
	elog "The new names are liblist, lcache, liblist_queue, and liblist_stack."
}
