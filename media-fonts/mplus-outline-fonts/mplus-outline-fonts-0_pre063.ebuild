# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit font

MY_P="mplus-${PV/0_pre/TESTFLIGHT-}"

DESCRIPTION="M+ Japanese outline fonts"
HOMEPAGE="http://mplus-fonts.osdn.jp/ http://ossipedia.ipa.go.jp/ipafont/"
SRC_URI="mirror://sourceforge.jp/mplus-fonts/62344/${MY_P}.tar.xz"

LICENSE="mplus-fonts ipafont? ( IPAfont )"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~x86 ~ppc-macos ~x86-macos"
IUSE="ipafont"
RESTRICT="binchecks strip"

DEPEND="ipafont? (
		media-gfx/fontforge
		media-fonts/ja-ipafonts
	)"
RDEPEND=""
S="${WORKDIR}/${MY_P}"

FONT_SUFFIX="ttf"
FONT_S="${S}"
DOCS="README_J README_E"

IPAFONT_DIR="${EPREFIX}/usr/share/fonts/ja-ipafonts"

src_prepare() {
	if use ipafont; then
		cp -p "${IPAFONT_DIR}"/ipag.ttf "${S}" || die
	fi
	default
}

src_compile() {
	if use ipafont; then
		fontforge -script m++ipa.pe || die
		rm -f ipag.ttf
	fi
}
