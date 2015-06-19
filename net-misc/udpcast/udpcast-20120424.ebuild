# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/udpcast/udpcast-20120424.ebuild,v 1.6 2015/05/24 06:16:58 jer Exp $

EAPI=5
inherit eutils

DESCRIPTION="Multicast file transfer tool"
HOMEPAGE="http://www.udpcast.linux.lu/"
SRC_URI="http://www.udpcast.linux.lu/download/${P}.tar.bz2"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="dev-lang/perl"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-fd_set.patch \
		"${FILESDIR}"/${P}-gentoo.patch
}

src_install() {
	default
	dodoc *.txt
}
