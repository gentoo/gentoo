# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

MY_P="${PN/font/}${PV/\./_}"

DESCRIPTION="Handwritten Japanese fixed-width TrueType font"
HOMEPAGE="http://www.geocities.jp/teardrops_in_aquablue/"
SRC_URI="http://www.geocities.jp/teardrops_in_aquablue/fnt/${MY_P}.zip"

LICENSE="aquafont"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="X"
# Only installs fonts
RESTRICT="strip binchecks"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/${MY_P}"

DOCS="readme.txt"
FONT_CONF=( "${FILESDIR}"/60-aquafont.conf )
FONT_S="${S}"
FONT_SUFFIX="ttf"

pkg_postinst() {
	font_pkg_postinst

	echo
	elog "To use aquafont instead of the default font for monospace use:"
	elog "   eselect fontconfig enable 60-aquafont.conf"
	echo
}
