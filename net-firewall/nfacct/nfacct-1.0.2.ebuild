# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit linux-info

DESCRIPTION="Command line tool to create/retrieve/delete accounting objects in NetFilter"
HOMEPAGE="https://www.netfilter.org/projects/nfacct/"
SRC_URI="https://www.netfilter.org/projects/${PN}/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc64 x86"

RDEPEND="
	net-libs/libmnl
	>=net-libs/libnetfilter_acct-1.0.3
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

CONFIG_CHECK="~NETFILTER_NETLINK_ACCT"
