# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/unifont/unifont-7.0.01.ebuild,v 1.3 2015/02/20 13:21:14 armin76 Exp $

EAPI=5

inherit eutils font toolchain-funcs

DESCRIPTION="GNU Unifont - a Pan-Unicode X11 bitmap iso10646 font"
HOMEPAGE="http://unifoundry.com/"
SRC_URI="mirror://gnu/${PN}/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="fontforge utils"

DEPEND="
	fontforge? (
		app-text/bdf2psf
		dev-lang/perl
		dev-perl/GD[png(-)]
		media-gfx/fontforge
		x11-apps/bdftopcf
	)
"
RDEPEND="
	utils? (
		dev-lang/perl
		dev-perl/GD[png(-)]
	)
"

src_prepare() {
	epatch "${FILESDIR}/unifont-7.0.01-font-Makefile.patch"
	sed -i -e 's/install -s/install/' src/Makefile || die
	epatch_user
}

src_compile() {
	if use fontforge || use utils; then
		tc-export CC
		makeargs=(
			CFLAGS="${CFLAGS}"
			BUILDFONT=$(usex fontforge 1 '')
		)
		emake -j1 "${makeargs[@]}"
	fi
}

src_install() {
	makeargs+=(
		DESTDIR="${ED%/}"
		PCFDEST="${ED%/}${FONTDIR}"
		TTFDEST="${ED%/}${FONTDIR}"
		USRDIR=usr
	)
	use utils || makeargs+=( -C font )
	emake -j1 "${makeargs[@]}" install
	font_xfont_config
	font_fontconfig
}
