# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="A Library to Access SMI MIB Information"
HOMEPAGE="https://www.ibr.cs.tu-bs.de/projects/libsmi/ https://gitlab.ibr.cs.tu-bs.de/nm/libsmi"
SRC_URI="https://www.ibr.cs.tu-bs.de/projects/libsmi/download/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~loong ~m68k ppc ppc64 ~riscv ~s390 ~sparc x86"
RESTRICT="test"

# libsmi-0.5.0-implicit-function-declarations.patch touches parser
BDEPEND="
	app-alternatives/lex
	app-alternatives/yacc
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.5.0-implicit-function-declarations.patch
	"${FILESDIR}"/${PN}-0.5.0-clang-15-configure.patch
	"${FILESDIR}"/${PN}-0.5.0-fix-macro-clang16.patch
	"${FILESDIR}"/${PN}-0.5.0-fix-bison-race.patch
)

src_prepare() {
	default

	# Make sure to flush out all pre-generated parsers as patch them
	# for bug #869149.
	rm lib/{parser-smi.c,parser-smi.tab.h,parser-sming.c,parser-sming.tab.h} || die
	rm lib/{parser-yang.c,parser-yang.tab.h} || die
	rm lib/{scanner-smi.c,scanner-sming.c,scanner-yang.c} || die

	eautoreconf
}

src_configure() {
	# bug #944131
	append-cflags -std=gnu17

	econf
}

src_test() {
	# sming test is known to fail and some other fail if LC_ALL!=C:
	# https://mail.ibr.cs.tu-bs.de/pipermail/libsmi/2008-March/001014.html
	sed -i '/^[[:space:]]*smidump-sming.test \\$/d' test/Makefile
	LC_ALL=C emake -j1 check
}

src_install() {
	default

	dodoc ANNOUNCE ChangeLog README THANKS TODO \
		doc/{*.txt,smi.dia,smi.dtd,smi.xsd} smi.conf-example

	find "${ED}" -name '*.la' -delete || die
}
