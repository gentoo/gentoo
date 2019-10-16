# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
FONT_PN=mplus

inherit font

MY_P="mplus_bitmap_fonts-${PV}"

DESCRIPTION="M+ Japanese bitmap fonts"
HOMEPAGE="http://mplus-fonts.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/${PN}/5030/${MY_P}.tar.gz"

LICENSE="mplus-fonts"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86"
IUSE="X"

DEPEND=">=x11-apps/mkfontscale-1.2.0
	x11-apps/bdftopcf"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

# Only installs fonts
RESTRICT="strip binchecks"

src_install(){
	DESTDIR="${D}${FONTDIR}" ./install_mplus_fonts || die
	dodoc README* INSTALL*
}
