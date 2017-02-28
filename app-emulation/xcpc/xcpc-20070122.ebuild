# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="XCPC is a portable Amstrad CPC 464/664/6128 emulator written in C."
HOMEPAGE="http://www.xcpc-emulator.net/doku.php/index"
SRC_URI="http://sourceforge.net/projects/${PN}/files/${PN}/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="app-emulation/libdsk"
