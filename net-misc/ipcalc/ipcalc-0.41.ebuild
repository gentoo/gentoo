# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="IP Calculator prints broadcast/network/etc for an IP address and netmask"
LICENSE="GPL-2+"
HOMEPAGE="http://jodies.de/ipcalc"
SRC_URI="${HOMEPAGE}-archive/${P}.tar.gz"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

RDEPEND=">=dev-lang/perl-5.6.0"

src_install () {
	dobin ${PN}
	dodoc changelog contributors
}
