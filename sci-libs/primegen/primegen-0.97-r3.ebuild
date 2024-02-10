# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Small, fast library to generate primes in order"
HOMEPAGE="https://cr.yp.to/primegen.html"
SRC_URI="https://cr.yp.to/primegen/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"

PATCHES=(
	"${FILESDIR}"/${P}-man.patch
	"${FILESDIR}"/${P}-missing-headers.patch
	"${FILESDIR}"/${P}-respect-ar-ranlib.patch
	"${FILESDIR}"/${PN}-0.97-main-rettype.patch
)

src_prepare() {
	default

	local file
	while IFS="" read -d $'\0' -r file; do
		sed -i -e 's:\(primegen.a\):lib\1:' "${file}" || die
	done < <(find . -type f -print0)
	mkdir usr || die
}

src_configure() {
	# Fixes bug #161015
	append-flags -fsigned-char
	echo "$(tc-getCC) ${CFLAGS} ${CPPFLAGS}" > conf-cc || die
	echo "${S}/usr" > conf-home || die
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld || die
	tc-export AR RANLIB
}

src_test() {
	[[ $(./primes 1 100000000 | md5sum ) == "4e2b0027288a27e9c99699364877c9db "* ]] || die "test failed"
}

src_install() {
	dobin primegaps primes primespeed
	doman primegaps.1 primes.1 primespeed.1 primegen.3
	dolib.a libprimegen.a
	# include the 2 typedefs to avoid collision (bug #248327)
	sed -i \
		-e "s/#include \"uint32.h\"/$(grep typedef uint32.h)/" \
		-e "s/#include \"uint64.h\"/$(grep typedef uint64.h)/" \
		primegen.h || die

	doheader primegen.h
	dodoc BLURB CHANGES README TODO
}
