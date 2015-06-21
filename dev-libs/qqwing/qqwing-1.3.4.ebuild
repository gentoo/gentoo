# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/qqwing/qqwing-1.3.4.ebuild,v 1.3 2015/06/21 10:54:18 zlogene Exp $

EAPI=5

inherit eutils

DESCRIPTION="Sudoku puzzle generator and solver"
HOMEPAGE="http://qqwing.com/"
SRC_URI="http://qqwing.com/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0/2"
KEYWORDS="amd64 ~arm ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_install() {
	default
	prune_libtool_files
}
