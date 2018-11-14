# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="Sudoku puzzle generator and solver"
HOMEPAGE="https://qqwing.com"
SRC_URI="https://qqwing.com/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0/2"
KEYWORDS="amd64 arm ~arm64 x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_install() {
	default
	prune_libtool_files
}
