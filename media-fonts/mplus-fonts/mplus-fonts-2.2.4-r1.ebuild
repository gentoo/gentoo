# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FONT_PN=mplus
MY_P="mplus_bitmap_fonts-${PV}"
inherit font

DESCRIPTION="M+ Japanese bitmap fonts"
HOMEPAGE="https://mplus-fonts.osdn.jp/about-en.html"
SRC_URI="mirror://sourceforge.jp/${PN}/5030/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="mplus-fonts"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ppc ppc64 s390 sparc x86"
IUSE="X"

# Only installs fonts
RESTRICT="strip binchecks"

BDEPEND="
	x11-apps/bdftopcf
	>=x11-apps/mkfontscale-1.2.0
"

src_install() {
	DESTDIR="${D}${FONTDIR}" ./install_mplus_fonts || die
	dodoc README* INSTALL*
}
