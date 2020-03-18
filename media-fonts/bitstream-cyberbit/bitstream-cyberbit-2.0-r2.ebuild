# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

DESCRIPTION="Cyberbit Unicode (including CJK) font"
HOMEPAGE="http://www.bitstream.com/"
SRC_URI="http://freebsd.nsu.ru/distfiles/cyberbit/Cyberbit.ZIP -> ${P}.zip https://www.minix3.org/distfiles-backup/cyberbit-ttf/Cyberbit.ZIP -> ${P}.zip http://mirror.uni-c.dk/pub/pkgsrc/distfiles/cyberbit-ttf/Cyberbit.ZIP -> ${P}.zip"
LICENSE="BitstreamCyberbit"

SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""
RESTRICT="bindist mirror"

S="${WORKDIR}"
FONT_S="${S}"
FONT_SUFFIX="ttf"
