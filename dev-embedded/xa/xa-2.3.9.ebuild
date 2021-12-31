# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="xa high-speed, two-pass portable 6502 cross-assembler"
HOMEPAGE="https://www.floodgap.com/retrotech/xa/"
SRC_URI="https://www.floodgap.com/retrotech/${PN}/dists/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}/${P}-Makefile.patch"
)
