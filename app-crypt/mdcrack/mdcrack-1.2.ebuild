# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/mdcrack/mdcrack-1.2.ebuild,v 1.6 2014/08/10 02:27:00 patrick Exp $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="A MD4/MD5/NTML hashes bruteforcer"
HOMEPAGE="http://mdcrack.df.ru/"
SRC_URI="http://mdcrack.df.ru/download/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="ncurses"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc4.diff \
		"${FILESDIR}"/${P}-asneeded.patch \
		"${FILESDIR}"/${P}-remove-interactive-test.diff

	use ncurses || \
		sed -i -e 's/^NCURSES/#NCURSES/g' \
			-e 's/^LIBS/#LIBS/g' Makefile
	sed -i -e '/^CFLAGS/d' \
		-e 's|make bin/mdcrack|$(MAKE) bin/mdcrack|g' \
		-e 's|make core|$(MAKE) core|g' Makefile
}

src_compile() {
	emake CC="$(tc-getCC)" little || die "emake failed"
}

src_test() {
	local failure=false

	make CC="$(tc-getCC)" fulltest || die "self test failed"

	for i in {1..20}; do
		if grep "Collision found" out$i ; then
			elog "Test $i: Passed"
		else
			elog "Test $i: Failed"
			failure=true
		fi
	done

	if $failure; then
		die "Some tests failed"
	fi
}

src_install() {
	dobin bin/mdcrack || die "dobin failed"
	dodoc BENCHMARKS CREDITS FAQ README TODO VERSIONS WWW || die
}
