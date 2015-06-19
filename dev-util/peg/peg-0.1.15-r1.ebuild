# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/peg/peg-0.1.15-r1.ebuild,v 1.1 2015/01/02 19:09:05 rafaelmartins Exp $

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Recursive-descent parser generators for C"
HOMEPAGE="http://piumarta.com/software/peg/"
SRC_URI="http://piumarta.com/software/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# FIXME: tests don't respect {C,LD}FLAGS and build stuff in runtime.
RESTRICT="test"

src_prepare() {
	sed -i \
		-e '/strip/d' \
		-e '/^CFLAGS/d' \
		-e 's/$(CC) $(CFLAGS) -o/$(CC) $(CFLAGS) $(LDFLAGS) -o/g' \
			Makefile || die "sed failed"
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dodir "/usr/bin"
	emake -j1 \
		ROOT="${D}" \
		PREFIX="/usr" \
		install
	rm -rf "${D}/usr/man" || die "rm failed"
	doman src/${PN}.1
}

src_test() {
	emake check
	emake test
}
