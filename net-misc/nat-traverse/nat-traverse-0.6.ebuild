# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/nat-traverse/nat-traverse-0.6.ebuild,v 1.3 2013/02/14 20:18:34 ago Exp $

DESCRIPTION="Traverse NAT gateways with the Use of UDP"
HOMEPAGE="http://linide.sourceforge.net/nat-traverse/"
SRC_URI="http://linide.sourceforge.net/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~mips ~ppc ~ppc64 x86"
IUSE=""

RDEPEND=">=dev-lang/perl-5.6.1"

src_install() {
	doman nat-traverse.1
	dobin nat-traverse

	dodoc ChangeLog README
}
