# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit toolchain-funcs

DESCRIPTION="Fast, reliable, simple package for creating and reading constant databases"
HOMEPAGE="https://cr.yp.to/cdb.html"
SRC_URI="https://cr.yp.to/${PN}/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

RDEPEND="!dev-db/tinycdb"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-errno.patch
	"${FILESDIR}"/${PN}-inline.patch
	"${FILESDIR}"/${PN}-stdint.patch
)
DOCS=( CHANGES README TODO VERSION )

src_prepare() {
	default

	sed -i \
		-e "s/head -1/head -n 1/g" \
		-e "s/ar /$(tc-getAR) /" \
		-e "s/ranlib /$(tc-getRANLIB) /" \
		Makefile
}

src_configure() {
	echo "$(tc-getCC) ${CFLAGS} -fPIC" >conf-cc   || die
	echo "$(tc-getCC) ${LDFLAGS}"      >conf-ld   || die
	echo "${EPREFIX}/usr"              >conf-home || die
}

src_install() {
	dobin ${PN}{dump,get,make{,-12,-sv},stats,test}

	# ok so ... first off, some automakes fail at finding
	# cdb.a, so install that now
	dolib.a *.a
	# then do this pretty little symlinking to solve the somewhat
	# cosmetic library issue at hand
	dosym ${PN}.a /usr/$(get_libdir)/lib${PN}.a

	# uint32.h needs installation too, otherwise compiles depending
	# on it will fail
	insinto /usr/include/${PN}
	doins ${PN}*.h {alloc,buffer,uint32}.h

	einstalldocs
}
