# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="Library for extracting DWARF data from code objects"
HOMEPAGE="https://www.prevanders.net/dwarf.html"
SRC_URI="https://github.com/davea42/libdwarf-code/releases/download/${P}/${P}.tar.xz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

src_prepare() {
	default

	# This test fails from time to time, we are going to remove it
	sed -i 's|dwarfdumpPE.sh||' test/Makefile.{in,am} || die
}
