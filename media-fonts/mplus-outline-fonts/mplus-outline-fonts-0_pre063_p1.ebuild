# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit font

MY_P="mplus-${PV/0_pre/TESTFLIGHT-}"
MY_P="${MY_P/_p1/a}"

DESCRIPTION="M+ Japanese outline fonts"
HOMEPAGE="https://mplus-fonts.osdn.jp/about-en.html"
SRC_URI="mirror://sourceforge.jp/mplus-fonts/62344/${MY_P}.tar.xz"

LICENSE="mplus-fonts ipafont? ( IPAfont )"
SLOT="0"
KEYWORDS="amd64 ~hppa ~loong ppc ~ppc64 x86"
IUSE="ipafont"
RESTRICT="binchecks strip"

BDEPEND="ipafont? (
		media-fonts/ja-ipafonts
		media-gfx/fontforge
	)"
S="${WORKDIR}/${MY_P}"

DOCS=( README_J README_E )

FONT_SUFFIX="ttf"

IPAFONT_DIR="${EPREFIX}/usr/share/fonts/ja-ipafonts"

src_prepare() {
	if use ipafont; then
		cp -p "${IPAFONT_DIR}"/ipag.ttf . || die
	fi
	default
}

src_compile() {
	if use ipafont; then
		fontforge -script m++ipa.pe || die
		rm ipag.ttf || die
	fi
}
