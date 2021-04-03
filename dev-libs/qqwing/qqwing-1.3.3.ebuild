# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools epatch

DESCRIPTION="Sudoku puzzle generator and solver"
HOMEPAGE="https://qqwing.com"
SRC_URI="https://github.com/stephenostermiller/${PN}/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm x86"

src_prepare() {
	# Make autotools work out of the box
	epatch "${FILESDIR}"/${PN}-1.3.0-autotools.patch

	eautoreconf
}
