# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-engines/xzip/xzip-1.8.2-r2.ebuild,v 1.12 2015/02/06 13:42:29 ago Exp $

EAPI=5
inherit games

DESCRIPTION="X interface to Z-code based text games"
HOMEPAGE="http://www.eblong.com/zarf/xzip.html"
SRC_URI="http://www.eblong.com/zarf/ftp/xzip182.tar.Z"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""
RESTRICT="test"

DEPEND="x11-libs/libX11"
RDEPEND=${DEPEND}

S=${WORKDIR}/xzip

src_compile() {
	emake \
		CFLAGS="${CFLAGS} -DAUTO_END_MODE" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dogamesbin xzip
	dodoc README
	doman xzip.1
	prepgamesdirs
}
