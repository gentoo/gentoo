# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/dirac/dirac-1.0.2.ebuild,v 1.13 2015/01/29 19:15:56 mgorny Exp $

EAPI=4
inherit autotools eutils

DESCRIPTION="Open Source video codec"
HOMEPAGE="http://dirac.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="debug doc cpu_flags_x86_mmx static-libs"

RDEPEND=""
DEPEND="
	doc? (
		app-doc/doxygen
		virtual/latex-base
		media-gfx/graphviz
		app-text/dvipdfm
	)"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.5.2-doc.patch
	AT_M4DIR="m4" eautoreconf
}

src_configure() {
	export VARTEXFONTS="${T}/fonts"

	econf \
		$(use_enable static-libs static) \
		$(use_enable cpu_flags_x86_mmx mmx) \
		$(use_enable debug) \
		$(use_enable doc)
}

src_install() {
	emake \
		DESTDIR="${D}" \
		htmldir="${EPREFIX}/usr/share/doc/${PF}/html" \
		latexdir="${EPREFIX}/usr/share/doc/${PF}/programmers" \
		algodir="${EPREFIX}/usr/share/doc/${PF}/algorithm" \
		faqdir="${EPREFIX}/usr/share/doc/${PF}" \
		install

	dodoc AUTHORS ChangeLog NEWS README TODO

	find "${ED}"usr -name '*.la' -exec rm -f {} +
}
