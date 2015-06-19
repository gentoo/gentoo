# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/jemalloc/jemalloc-2.2.5-r1.ebuild,v 1.9 2014/12/28 11:56:01 blueness Exp $

EAPI=4

inherit autotools eutils

DESCRIPTION="Jemalloc is a general-purpose scalable concurrent allocator"
HOMEPAGE="http://www.canonware.com/jemalloc/"
SRC_URI="http://www.canonware.com/download/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~mips ppc ppc64 x86"

IUSE="debug static-libs stats"

DEPEND=""
RDEPEND=""

src_prepare() {
	epatch \
		"${FILESDIR}/${PN}-strip-optimization.patch" \
		"${FILESDIR}/${PN}-2.2.1-no-pprof.patch" \
		"${FILESDIR}/${PN}-2.2.5_fix_html_install.patch"

	eautoreconf
}

src_configure() {
	econf \
		--with-jemalloc-prefix=j \
		$(use_enable debug) \
		$(use_enable stats)
}

src_install() {
	emake DESTDIR="${ED}" install || die
	dodoc ChangeLog README
	dohtml doc/jemalloc.html

	use static-libs || find "${ED}" -name '*.a' -exec rm -f {} +
}
