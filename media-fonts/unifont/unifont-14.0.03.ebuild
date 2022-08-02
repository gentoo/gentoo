# Copyright 2003-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font toolchain-funcs

DESCRIPTION="GNU Unifont - a Pan-Unicode X11 bitmap iso10646 font"
HOMEPAGE="http://unifoundry.com/"
SRC_URI="mirror://gnu/${PN}/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~ia64 ~loong ppc ppc64 ~s390 sparc x86"
IUSE="fontforge utils"

BDEPEND="
	fontforge? (
		app-text/bdf2psf
		dev-lang/perl
		dev-perl/GD[png(+)]
		media-gfx/fontforge
		x11-apps/bdftopcf
	)
"
RDEPEND="
	utils? (
		dev-lang/perl
		dev-perl/GD[png(+)]
	)
"

src_compile() {
	buildargs=(
		BUILDFONT=$(usex fontforge 1 '')
		CC="$(tc-getCC)"
		CFLAGS="${CFLAGS}"
		INSTALL="${INSTALL-install}"
	)

	if use fontforge || use utils; then
		# -j1 for bug #843584
		emake -j1 "${buildargs[@]}"
	fi
}

src_install() {
	local installargs=(
		COMPRESS=0
		DESTDIR="${ED}"
		PCFDEST="${ED}${FONTDIR}"
		TTFDEST="${ED}${FONTDIR}"
	)
	use utils || installargs+=( -C font )
	emake "${buildargs[@]}" "${installargs[@]}" install
	font_xfont_config
	font_fontconfig
}
