# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
