# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Change the speed of your CD drive"
HOMEPAGE="http://linuxfocus.org/~guido/"
SRC_URI="http://linuxfocus.org/~guido/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~mips ppc x86"

src_prepare() {
	default
	sed -i Makefile \
		-e 's| -o | $(LDFLAGS)&|g' \
		|| die "sed Makefile failed"
}

src_compile() {
	emake CFLAGS="${CFLAGS} -Wall -Wno-unused" CC=$(tc-getCC)
}

src_install() {
	emake PREFIX="${D}/usr" install
	dodoc README
}
