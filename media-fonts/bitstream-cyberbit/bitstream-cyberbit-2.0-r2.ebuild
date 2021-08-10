# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Cyberbit Unicode (including CJK) font"
HOMEPAGE="http://www.bitstream.com/"
SRC_URI="http://freebsd.nsu.ru/distfiles/cyberbit/Cyberbit.ZIP -> ${P}.zip
	https://www.minix3.org/distfiles-backup/cyberbit-ttf/Cyberbit.ZIP -> ${P}.zip
	http://mirror.uni-c.dk/pub/pkgsrc/distfiles/cyberbit-ttf/Cyberbit.ZIP -> ${P}.zip"
S="${WORKDIR}"

LICENSE="BitstreamCyberbit"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE=""

RESTRICT="bindist mirror"

BDEPEND="app-arch/unzip"

FONT_SUFFIX="ttf"
