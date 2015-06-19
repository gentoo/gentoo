# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/netstat-nat/netstat-nat-1.4.10.ebuild,v 1.8 2014/07/18 19:58:26 jer Exp $

EAPI=5
inherit autotools eutils

DESCRIPTION="Display NAT connections"
HOMEPAGE="http://tweegy.nl/projects/netstat-nat/index.html"
SRC_URI="http://tweegy.nl/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc sparc x86"

src_prepare() {
	epatch "${FILESDIR}"/${P}-install.patch
	eautoreconf
}
