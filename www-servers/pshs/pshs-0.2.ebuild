# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/pshs/pshs-0.2.ebuild,v 1.1 2011/11/16 21:55:56 mgorny Exp $

EAPI=4
inherit autotools-utils

DESCRIPTION="Pretty small HTTP server - a command-line tool to share files"
HOMEPAGE="https://github.com/mgorny/pshs/"
SRC_URI="mirror://github/mgorny/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+magic +netlink upnp"

RDEPEND=">=dev-libs/libevent-2
	magic? ( sys-apps/file )
	upnp? ( net-libs/miniupnpc )"
DEPEND="${RDEPEND}
	netlink? ( sys-apps/iproute2
		>=sys-kernel/linux-headers-2.6.27 )"
# libnetlink is static only ATM

src_configure() {
	myeconfargs=(
		$(use_enable magic libmagic)
		$(use_enable netlink)
		$(use_enable upnp)
	)

	autotools-utils_src_configure
}
