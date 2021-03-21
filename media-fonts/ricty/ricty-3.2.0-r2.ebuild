# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="Ricty"
inherit font

DESCRIPTION="Beautiful sans-serif monotype Japanese font designed for code listings"
HOMEPAGE="https://rictyfonts.github.io/"
SRC_URI="https://github.com/yascentur/${MY_PN}/tarball/${PV} -> ${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/yascentur-${MY_PN}-b9d8b9c"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

BDEPEND="
	media-fonts/inconsolata
	>=media-fonts/mix-mplus-ipa-20111002
	media-gfx/fontforge
"

FONT_SUFFIX="ttf"

# Only installs fonts.
RESTRICT="strip binchecks"

src_compile() {
	sh ricty_generator.sh \
		"${EPREFIX}/usr/share/fonts/inconsolata/Inconsolata-Regular.ttf" \
		"${EPREFIX}/usr/share/fonts/mix-mplus-ipa/migu-1m-regular.ttf" \
		"${EPREFIX}/usr/share/fonts/mix-mplus-ipa/migu-1m-bold.ttf" || die
}
