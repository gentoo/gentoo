# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Utility to trace the route of IP packets"
HOMEPAGE="https://traceroute.sourceforge.net/"
SRC_URI="mirror://sourceforge/traceroute/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="static"

RDEPEND="!net-misc/iputils[traceroute6(-)]"

src_compile() {
	use static && append-ldflags -static
	# bug #432116
	append-ldflags -L../libsupp
	tc-export AR CC RANLIB

	emake env=yes
}

src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" install
	dodoc ChangeLog CREDITS README TODO
	dosym traceroute /usr/bin/traceroute6
	dosym traceroute.8 /usr/share/man/man8/traceroute6.8
}
