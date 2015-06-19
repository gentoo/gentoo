# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/clockspeed-conf/clockspeed-conf-0.4.5-r1.ebuild,v 1.2 2011/01/29 23:23:18 bangert Exp $

inherit eutils

DESCRIPTION="scripts to setup a clockspeed client and/or a taiclockd server"
HOMEPAGE="http://foo42.de/devel/sysutils/clockspeed-conf/"
SRC_URI="http://foo42.de/distfiles/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-misc/clockspeed
	virtual/daemontools"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_install() {
	dobin clockspeed-conf taiclockd-conf || die "dobin"
	doman clockspeed-conf.8 taiclockd-conf.8
	dodoc README TODO
}
