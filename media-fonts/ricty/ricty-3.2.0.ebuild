# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit font

MY_PN="Ricty"
DESCRIPTION="A beautiful sans-serif monotype Japanese font designed for code listings"
HOMEPAGE="http://save.sys.t.u-tokyo.ac.jp/~yusa/fonts/ricty.html"
#SRC_URI="http://save.sys.t.u-tokyo.ac.jp/~yusa/fonts/ricty/${MY_PN}-${PV}.tar.gz"
SRC_URI="https://github.com/yascentur/${MY_PN}/tarball/${PV} -> ${MY_PN}-${PV}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE=""

DEPEND="media-fonts/inconsolata
	>=media-fonts/mix-mplus-ipa-20111002
	media-gfx/fontforge"
RDEPEND=""

#S="${WORKDIR}/yascentur-${MY_PN}-*"
S="${WORKDIR}/yascentur-${MY_PN}-b9d8b9c"

FONT_SUFFIX="ttf"
FONT_S="${S}"

# Only installs fonts.
RESTRICT="strip binchecks"

src_compile() {
	sh ricty_generator.sh \
		"${EPREFIX}/usr/share/fonts/inconsolata/Inconsolata.otf" \
		"${EPREFIX}/usr/share/fonts/mix-mplus-ipa/migu-1m-regular.ttf" \
		"${EPREFIX}/usr/share/fonts/mix-mplus-ipa/migu-1m-bold.ttf" || die
}
