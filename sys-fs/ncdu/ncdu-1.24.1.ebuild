# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

DESCRIPTION="NCurses Disk Usage"
HOMEPAGE="
	https://ncdu.landless-city.net
	https://github.com/BratishkaErik/ncdu
"
SRC_URI="https://github.com/BratishkaErik/ncdu/releases/download/v${PV}/${P}-src.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-macos"

DEPEND="sys-libs/ncurses:=[unicode(+)]"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( "README.md" )
