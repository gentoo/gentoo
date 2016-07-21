# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

IUSE=""

S="${WORKDIR}"

DESCRIPTION="automatically find a clipping border for a sequence of pgm images"
HOMEPAGE="http://www.lallafa.de/bp/pgmfindclip.html"
SRC_URI="http://www.lallafa.de/bp/files/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

src_unpack() {
	unpack ${A}

	sed -i -e 's:gcc .* -o:$(CC) $(CFLAGS) $(LDFLAGS) -o:' "${S}"/Makefile
}

src_compile () {
	emake CC="$(tc-getCC)" || die
}

src_install () {
	dobin ${PN} || die
}
