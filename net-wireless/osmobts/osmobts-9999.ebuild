# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools git-2

DESCRIPTION="Osmocom BTS-Side code (Abis, scheduling)"
HOMEPAGE="http://openbsc.osmocom.org/trac/wiki/OsmoBTS"
EGIT_REPO_URI="git://git.osmocom.org/osmo-bts.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="net-libs/libosmocore net-libs/libosmo-abis"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
	wget -O "${S}"/include/openbsc/gsm_data_shared.h http://cgit.osmocom.org/openbsc/plain/openbsc/include/openbsc/gsm_data_shared.h || die
	wget -O "${S}"/src/common/gsm_data_shared.c http://cgit.osmocom.org/openbsc/plain/openbsc/src/libcommon/gsm_data_shared.c || die

}

src_configure() {
	econf --enable-trx --with-openbsc="${S}"/include/openbsc
}
