# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools git-2

DESCRIPTION="Osmocom BTS-Side code (Abis, scheduling)"
HOMEPAGE="http://openbsc.osmocom.org/trac/wiki/OsmoBTS"
EGIT_REPO_URI="git://git.osmocom.org/osmo-bts.git"
EGIT_BRANCH="jolly/trx"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="net-libs/libosmocore net-libs/libosmo-abis"
RDEPEND="${DEPEND}"

src_prepare() {
	mkdir -p ../openbsc/openbsc/include/openbsc ../openbsc/openbsc/src/libcommon/ || die
	wget -O ../openbsc/openbsc/include/openbsc/gsm_data_shared.h http://cgit.osmocom.org/openbsc/plain/openbsc/include/openbsc/gsm_data_shared.h?h=jolly/testing || die
	wget -O ../openbsc/openbsc/src/libcommon/gsm_data_shared.c http://cgit.osmocom.org/openbsc/plain/openbsc/src/libcommon/gsm_data_shared.c?h=jolly/testing || die
	eautoreconf
}

src_configure() {
	econf --enable-trx
}
