# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils font toolchain-funcs

DESCRIPTION="GNU Unifont - a Pan-Unicode X11 bitmap iso10646 font"
HOMEPAGE="http://unifoundry.com/"
SRC_URI="http://unifoundry.com/pub/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="fontforge"

DEPEND="
	fontforge? (
		media-gfx/fontforge
		x11-apps/bdftopcf
	)
"
RDEPEND=""

src_prepare() {
	sed -i -e 's/install -s/install/' src/Makefile || die
}

src_compile() {
	tc-export CC
	makeargs=(
		CFLAGS="${CFLAGS}"
		UNASSIGNED=
	)
	use fontforge && emake -j1 "${makeargs[@]}"
}

src_install() {
	makeargs+=(
		DESTDIR="${ED}"
		PCFDEST="${ED}${FONTDIR}"
		TTFDEST="${ED}${FONTDIR}"
		USRDIR=usr
	)
	emake -j1 "${makeargs[@]}" install
	font_xfont_config
	font_fontconfig
}
