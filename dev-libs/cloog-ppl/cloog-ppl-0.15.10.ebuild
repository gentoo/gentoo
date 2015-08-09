# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit autotools

DESCRIPTION="Port of CLooG (Chunky LOOp Generator) to PPL (Parma Polyhedra Library)"
HOMEPAGE="http://repo.or.cz/w/cloog-ppl.git"
SRC_URI="ftp://gcc.gnu.org/pub/gcc/infrastructure/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~sparc-solaris"
IUSE="static-libs"

RDEPEND="dev-libs/ppl
	dev-libs/gmp"
DEPEND="${RDEPEND}"

src_prepare() {
	mkdir m4
	eautoreconf
}

src_configure() {
	econf \
		--with-ppl \
		--includedir="${EPREFIX}"/usr/include/cloog-ppl \
		$(use_enable static-libs static)
}

src_install() {
	default
	use static-libs || find "${ED}" -name libcloog.la -delete
	mv "${ED}"usr/bin/cloog{,-ppl} || die
	mv "${ED}"usr/share/info/cloog{,-ppl}.info || die
}
