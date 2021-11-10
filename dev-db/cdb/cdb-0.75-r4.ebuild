# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Fast, reliable, simple package for creating and reading constant databases"
HOMEPAGE="https://cr.yp.to/cdb.html"
SRC_URI="https://cr.yp.to/${PN}/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

DEPEND="!dev-db/tinycdb"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-errno.patch
	"${FILESDIR}"/${PN}-inline.patch
	"${FILESDIR}"/${PN}-stdint.patch
)

src_prepare() {
	default

	sed -i \
		-e "s/head -1/head -n 1/g" \
		-e "s/ar /$(tc-getAR) /" \
		Makefile
}

src_configure() {
	echo "$(tc-getCC) ${CFLAGS} -fPIC" > conf-cc || die
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld || die
	echo "${EPREFIX}/usr" > conf-home || die
}

src_install() {
	dobin cdbdump cdbget cdbmake cdbmake-12 cdbmake-sv cdbstats cdbtest

	# ok so ... first off, some automakes fail at finding
	# cdb.a, so install that now
	dolib.a *.a

	# then do this pretty little symlinking to solve the somewhat
	# cosmetic library issue at hand
	dosym cdb.a /usr/$(get_libdir)/libcdb.a

	# uint32.h needs installation too, otherwise compiles depending
	# on it will fail
	insinto /usr/include/cdb
	doins cdb*.h buffer.h alloc.h uint32.h

	dodoc CHANGES FILES README SYSDEPS TODO VERSION
}
