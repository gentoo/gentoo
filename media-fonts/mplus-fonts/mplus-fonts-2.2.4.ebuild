# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/mplus-fonts/mplus-fonts-2.2.4.ebuild,v 1.14 2007/07/22 07:49:53 dirtyepic Exp $

IUSE="X"

MY_P="mplus_bitmap_fonts-${PV}"

DESCRIPTION="M+ Japanese bitmap fonts"
HOMEPAGE="http://mplus-fonts.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/${PN}/5030/${MY_P}.tar.gz"

LICENSE="mplus-fonts"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"

DEPEND="x11-apps/mkfontdir
		x11-apps/bdftopcf"
RDEPEND=""

S="${WORKDIR}/${MY_P}"
FONTPATH="/usr/share/fonts/mplus"

# Only installs fonts
RESTRICT="strip binchecks"

src_install(){
	DESTDIR="${D}${FONTPATH}" ./install_mplus_fonts || die
	dodoc README* INSTALL*
}
