# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="A tool for determining a firewall's rule set"
HOMEPAGE="http://packetfactory.openwall.net/projects/firewalk/"
SRC_URI="mirror://gentoo/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

DEPEND="
	dev-libs/libdnet
	net-libs/libnet:1.1
	net-libs/libpcap
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/Firewalk"

DOCS=( README TODO BUGS )

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc3.4.diff
}

src_install() {
	default
	doman man/firewalk.8
}
