# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/liblzw/liblzw-0.1.2.ebuild,v 1.5 2008/12/07 12:02:55 vapier Exp $

DESCRIPTION="small C library for reading LZW compressed files (.Z)"
HOMEPAGE="http://freestdf.sourceforge.net/liblzw.php"
SRC_URI="mirror://sourceforge/freestdf/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 arm hppa ia64 m68k s390 sh x86"
IUSE=""

DEPEND=""

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog NEWS README
}
