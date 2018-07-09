# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils git-r3

DESCRIPTION="OpenBSC, OsmoSGSN, OsmoBSC and other programs"
HOMEPAGE="http://openbsc.osmocom.org/trac/wiki/OpenBSC"
EGIT_REPO_URI="git://git.osmocom.org/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+gprs"

DEPEND="
	gprs? ( net-wireless/openggsn )
	net-libs/libosmocore
	net-libs/libosmo-abis
	net-libs/libosmo-netif
	dev-db/libdbi"
RDEPEND="${DEPEND}
	dev-db/libdbi-drivers[sqlite]
	dev-db/sqlite:3"

S="${WORKDIR}/${P}/${PN}"

src_prepare() {
	epatch_user
	eautoreconf
}
