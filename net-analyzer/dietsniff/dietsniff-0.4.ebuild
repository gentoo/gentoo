# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit toolchain-funcs vcs-snapshot

DESCRIPTION="small and static packet sniffer based on dietlibc and libowfat"
HOMEPAGE="https://github.com/hynek/dietsniff"
SRC_URI="https://github.com/hynek/dietsniff/tarball/a80c0e64b3 -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="dev-libs/libowfat
	dev-libs/dietlibc"

src_prepare() {
	sed -e '/^prefix=/s:=.*:=/usr:' \
		-e '/^MAN1DIR=/s:man/man1:share/man/man1:' \
		-e '/^CC/s:=:?=:' \
		-e '/^CFLAGS/s:=:+=:' \
		-e '/^LDFLAGS/s:=-s:+=:' \
		-e '/^dietsniff/,+3s: -o : $(LDFLAGS) -o :' \
		-e '/^dietsniff/,+3s:strip:#strip:' \
		-i Makefile
	export CC="diet -Os $(tc-getCC)"
}

src_install() {
	default

	dodoc AUTHORS ChangeLog README
}
