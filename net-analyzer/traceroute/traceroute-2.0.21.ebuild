# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/traceroute/traceroute-2.0.21.ebuild,v 1.2 2015/04/25 01:45:29 vapier Exp $

EAPI=5

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Utility to trace the route of IP packets"
HOMEPAGE="http://traceroute.sourceforge.net/"
SRC_URI="mirror://sourceforge/traceroute/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~arm-linux ~x86-linux"
IUSE="static"

RDEPEND="!<net-misc/iputils-20121221-r1
	!net-misc/iputils[traceroute]"

src_compile() {
	use static && append-ldflags -static
	tc-export AR CC RANLIB
	emake env=yes
}

src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" install
	dodoc ChangeLog CREDITS README TODO
	dosym traceroute /usr/bin/traceroute6
	dosym traceroute.8 /usr/share/man/man8/traceroute6.8
}
