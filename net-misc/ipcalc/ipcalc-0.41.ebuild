# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ipcalc/ipcalc-0.41.ebuild,v 1.15 2014/07/18 16:09:03 jer Exp $

EAPI=5

DESCRIPTION="calculates broadcast/network/etc... from an IP address and netmask"
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
