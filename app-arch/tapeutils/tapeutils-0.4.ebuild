# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

DESCRIPTION="Utilities for manipulation of tapes and tape image files"
HOMEPAGE="http://www.brouhaha.com/~eric/software/tapeutils/"
SRC_URI="http://www.brouhaha.com/~eric/software/tapeutils/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="!app-emulation/hercules"

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" || die
}

src_install() {
	dobin tapecopy tapedump || die
	# no docs to install
}
