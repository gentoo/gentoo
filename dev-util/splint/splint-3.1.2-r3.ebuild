# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Check C programs for vulnerabilities and programming mistakes"
HOMEPAGE="https://splint.org/"
SRC_URI="https://splint.org/downloads/${P}.src.tgz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv ~sparc x86 ~x64-macos"

BDEPEND="sys-devel/flex"

PATCHES=(
	"${FILESDIR}"/${PN}-3.1.2-musl.patch
)

src_prepare() {
	default

	# verbose compiler calls
	sed -i -e '/Compiling/d' src/Makefile.am || die
	# automake complains about trailing \
	sed -i -e '1600d' test/Makefile.am || die
	# do not install these header files twice
	sed -i -e '/\$(UnixHeaders)/s|stdio.h stdlib.h||g' lib/Makefile.am || die

	eautoreconf
}

src_configure() {
	# https://github.com/splintchecker/splint/issues/41 (bug #944117)
	append-cflags -std=gnu17

	# We do not need bison/yacc at all here
	# We definitely need libfl
	BISON=no LEXLIB=-lfl econf
}

src_compile() {
	local subdir
	# skip test/ subdir
	for subdir in src lib imports doc; do
		emake -j1 -C ${subdir}
	done
}

src_test() {
	emake -C test
}
