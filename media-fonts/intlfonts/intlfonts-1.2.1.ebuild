# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit font

IUSE="bdf"

DESCRIPTION="International X11 fixed fonts"
HOMEPAGE="http://www.gnu.org/directory/intlfonts.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd"

DEPEND="x11-apps/bdftopcf
		x11-apps/mkfontdir"
RDEPEND=""

src_compile() {
	econf --with-fontdir=/usr/share/fonts/${PN}
}

src_install() {
	emake install fontdir="${D}/usr/share/fonts/${PN}" || die
	find "${D}/usr/share/fonts/${PN}" -name '*.pcf' | xargs gzip -9
	use bdf || rm -rf "${D}/usr/share/fonts/${PN}/bdf"
	dodoc ChangeLog NEWS README
	dodoc Emacs.ap
	font_xfont_config
}
