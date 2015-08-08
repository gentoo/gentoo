# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit flag-o-matic toolchain-funcs

DESCRIPTION="A UNIX Shell with a simplified Scheme syntax"
HOMEPAGE="http://slon.ttk.ru/esh/"
SRC_URI="http://slon.ttk.ru/esh/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debug"

DEPEND=">=sys-libs/readline-4.1"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	emake clean

	sed -i \
		-e 's|-g ||' \
		-e 's|-DMEM_DEBUG ||' \
		-e 's|^CFLAGS|&+|g' \
		-e 's|$(CC) |&$(CFLAGS) $(LDFLAGS) |g' \
		-e 's:-ltermcap::' \
		Makefile || die
}

src_compile() {
	# For some reason, this tarball has binary files in it for x86.
	# Make clean so we can rebuild for our arch and optimization.

	use debug && append-flags -DMEM_DEBUG

	emake \
		CC="$(tc-getCC)" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin esh
	doinfo doc/esh.info
	dodoc CHANGELOG CREDITS GC_README HEADER READLINE-HACKS TODO
	dohtml doc/*.html
	docinto examples
	dodoc examples/*
}
