# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib eutils

DESCRIPTION="provides an environment for testing programs and Objective Caml modules"
HOMEPAGE="http://fort.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0/${PV}"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="dev-lang/ocaml:="
RDEPEND="${DEPEND}"
DOCS=( README )

src_prepare() {
	has_version '>=dev-lang/ocaml-4' && epatch "${FILESDIR}/${P}-ocaml4.patch"
	sed -i -e "s:\$(BINDIR):\$(DESTDIR)&:"\
		-e "s:\$(LIBDIR):\$(DESTDIR)&:" Makefile || die
}

src_configure() {
	./configure --bindir /usr/bin --libdir /usr/$(get_libdir)/ocaml || die
}
