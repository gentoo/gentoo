# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit eutils toolchain-funcs

DESCRIPTION="A MD4/MD5/NTML hashes bruteforcer"
HOMEPAGE="http://mdcrack.df.ru/"
SRC_URI="http://mdcrack.df.ru/download/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="ncurses"

DOCS=(
	BENCHMARKS CREDITS FAQ README TODO VERSIONS WWW
)

PATCHES=(
	"${FILESDIR}/${P}-gcc4.diff"
	"${FILESDIR}/${P}-asneeded.patch"
	"${FILESDIR}/${P}-remove-interactive-test.diff"
)

src_prepare() {
	default
	use ncurses || \
		sed -i -e 's/^NCURSES/#NCURSES/g' \
			-e 's/^LIBS/#LIBS/g' Makefile
	sed -i -e '/^CFLAGS/d' \
		-e 's|make bin/mdcrack|$(MAKE) bin/mdcrack|g' \
		-e 's|make core|$(MAKE) core|g' Makefile
}

src_compile() {
	emake CC="$(tc-getCC)" little
}

src_test() {
	local failure=false

	emake CC="$(tc-getCC)" fulltest

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
	einstalldocs
	dobin bin/mdcrack
}
