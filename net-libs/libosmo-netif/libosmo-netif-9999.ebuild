# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils git-2

DESCRIPTION="Utility functions for OsmocomBB, OpenBSC and related projects"
HOMEPAGE="http://bb.osmocom.org/trac/wiki/"
EGIT_REPO_URI="git://git.osmocom.org/${PN}.git"
KEYWORDS=""

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="net-libs/libosmocore net-libs/libosmo-abis"
DEPEND="${RDEPEND}"

src_prepare() {
	eautoreconf
}
