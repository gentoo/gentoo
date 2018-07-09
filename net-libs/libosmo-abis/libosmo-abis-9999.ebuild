# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools git-r3

DESCRIPTION="Osmocom library for A-bis interface"
HOMEPAGE="http://openbsc.osmocom.org/trac/wiki/libosmo-abis"
EGIT_REPO_URI="git://git.osmocom.org/${PN}.git"

LICENSE="GPL-2 LGPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="net-libs/ortp
	>=net-libs/libosmocore-0.11.0"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf
}
