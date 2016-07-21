# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Key binding editor for enlightenment 16"
HOMEPAGE="https://www.enlightenment.org/"
SRC_URI="mirror://sourceforge/enlightenment/${P}.tar.gz"

LICENSE="MIT-with-advertising"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

RDEPEND="=x11-libs/gtk+-2*"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_compile() {
	econf --enable-gtk2 || die
	emake || die
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc README ChangeLog AUTHORS
}
