# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="A file sorting program which uses the bogosort algorithm"
HOMEPAGE="http://www.lysator.liu.se/~qha/bogosort/"
SRC_URI="ftp://ulrik.haugen.se/pub/unix/bogosort/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ~mips ppc sparc x86 ~x86-linux ~ppc-macos"

PATCHES=(
	"${FILESDIR}"/xmalloc.patch
	"${FILESDIR}"/${P}-glibc-2.10.patch
	"${FILESDIR}"/${PN}-0.4.2-implicit-decl.patch
)

src_prepare() {
	default

	mv configure.{in,ac} || die

	sed -i \
		-e 's:-O0::' \
		-e '/maintainer-targets/d' \
		Makefile.am || die
	eautoreconf
}

src_configure() {
	tc-export CC
	econf
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc README NEWS ChangeLog AUTHORS
}
