# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="small C library for reading LZW compressed files (.Z)"
HOMEPAGE="https://github.com/vapier/liblzw"
SRC_URI="mirror://sourceforge/freestdf/${P}.tar.lzma"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 arm hppa ia64 m68k s390 sh x86"
IUSE=""

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog NEWS README
}
