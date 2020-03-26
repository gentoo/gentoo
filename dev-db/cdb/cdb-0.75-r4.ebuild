# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils multilib toolchain-funcs

KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

DESCRIPTION="Fast, reliable, simple package for creating and reading constant databases"
HOMEPAGE="http://cr.yp.to/cdb.html"
SRC_URI="http://cr.yp.to/cdb/${P}.tar.gz"
LICENSE="public-domain"
SLOT="0"
IUSE=""

DEPEND=">=sys-apps/sed-4
		!dev-db/tinycdb"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-errno.diff
	epatch "${FILESDIR}"/${P}-stdint.diff

	sed -i -e 's/head -1/head -n 1/g' Makefile \
		|| die "sed Makefile failed"
}

src_configure() {
	echo "$(tc-getCC) ${CFLAGS} -fPIC" > conf-cc
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld
	echo "${EPREFIX}/usr" > conf-home
}

src_install() {
	dobin cdbdump cdbget cdbmake cdbmake-12 cdbmake-sv cdbstats cdbtest

	# ok so ... first off, some automakes fail at finding
	# cdb.a, so install that now
	dolib *.a

	# then do this pretty little symlinking to solve the somewhat
	# cosmetic library issue at hand
	dosym cdb.a /usr/$(get_libdir)/libcdb.a

	# uint32.h needs installation too, otherwise compiles depending
	# on it will fail
	insinto /usr/include/cdb
	doins cdb*.h buffer.h alloc.h uint32.h

	dodoc CHANGES FILES README SYSDEPS TODO VERSION
}
