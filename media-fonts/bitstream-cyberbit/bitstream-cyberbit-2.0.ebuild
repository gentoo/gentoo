# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit font

DESCRIPTION="Cyberbit Unicode (including CJK) font"
HOMEPAGE="http://www.bitstream.com/"
SRC_URI="http://ftp.netscape.com/pub/communicator/extras/fonts/windows/Cyberbit.ZIP -> ${P}.zip"
LICENSE="BitstreamCyberbit"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""
RESTRICT="bindist mirror"

FONT_SUFFIX="ttf"
