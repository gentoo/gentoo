# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Traverse NAT gateways with the Use of UDP"
HOMEPAGE="https://gitlab.com/iblech/nat-traverse"
SRC_URI="https://gitlab.com/iblech/${PN}/blob/master/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"

RDEPEND=">=dev-lang/perl-5.6.1"

src_install() {
	doman nat-traverse.1
	dobin nat-traverse

	dodoc ChangeLog README
}
