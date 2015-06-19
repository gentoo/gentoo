# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/makepasswd/makepasswd-1.10.ebuild,v 1.26 2011/03/06 12:30:18 xmw Exp $

DESCRIPTION="Random password generator"
HOMEPAGE="http://packages.debian.org/stable/admin/makepasswd"
SRC_URI="mirror://debian/dists/potato/main/source/admin/${P/-/_}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ia64 ppc s390 sparc x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

RDEPEND="dev-lang/perl"

src_install() {
	dobin makepasswd || die
	doman makepasswd.1
	dodoc README CHANGES
}
