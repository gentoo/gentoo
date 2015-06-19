# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/nfacct/nfacct-1.0.1.ebuild,v 1.4 2013/05/20 11:21:49 pinkbyte Exp $

EAPI=5

inherit linux-info

DESCRIPTION="Command line tool to create/retrieve/delete accounting objects in NetFilter"
HOMEPAGE="http://netfilter.org/projects/nfacct"
SRC_URI="http://www.netfilter.org/projects/${PN}/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"

RDEPEND="net-libs/libmnl
	>=net-libs/libnetfilter_acct-1.0.2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

CONFIG_CHECK="~NETFILTER_NETLINK_ACCT"
