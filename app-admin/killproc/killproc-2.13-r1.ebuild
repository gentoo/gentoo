# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="killproc and assorted tools for boot scripts"
HOMEPAGE="http://ftp.suse.com/pub/projects/init/"
SRC_URI="ftp://ftp.suse.com/pub/projects/init/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ~mips ppc ppc64 s390 sparc x86"

src_prepare() {
	epatch \
		"${FILESDIR}/${P}-makefile.patch" \
		"${FILESDIR}/${P}-argz.patch"

	tc-export CC
	export COPTS=${CFLAGS}
}

src_install() {
	into /
	dosbin checkproc fsync killproc startproc usleep
	into /usr
	doman *.8 *.1
	dodoc README *.lsm
}
