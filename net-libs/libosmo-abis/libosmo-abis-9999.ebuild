# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libosmo-abis/libosmo-abis-9999.ebuild,v 1.2 2014/04/26 12:36:07 zx2c4 Exp $

EAPI=5

inherit autotools git-2

DESCRIPTION="Osmocom library for A-bis interface"
HOMEPAGE="http://openbsc.osmocom.org/trac/wiki/libosmo-abis"
EGIT_REPO_URI="git://git.osmocom.org/${PN}.git"
EGIT_BRANCH="jolly/multi-trx"

LICENSE="GPL-2 LGPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="net-libs/ortp"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}
