# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

DESCRIPTION="Effectively suppresses illegal DHCP servers on the LAN"
HOMEPAGE="http://www.netpatch.ru/dhcdrop.html"
SRC_URI="http://www.netpatch.ru/projects/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86"

IUSE="static"

RDEPEND="!static? ( net-libs/libpcap )"
DEPEND="static? ( net-libs/libpcap[static-libs] )
	${RDEPEND}"

DOCS=( AUTHORS ChangeLog INSTALL NEWS README )

src_prepare() {
	epatch_user
}

src_configure() {
	econf $(use static && echo "--enable-static-build")
}
