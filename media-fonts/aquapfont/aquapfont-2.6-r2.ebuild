# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

MY_P="${PN/font/}${PV/\./_}"

DESCRIPTION="Very pretty Japanese proportional truetype font"
HOMEPAGE="http://aquablue.milkcafe.to/"
SRC_URI="http://aquablue.milkcafe.to/tears/font/${MY_P}.zip"

LICENSE="aquafont"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
# Only installs fonts
RESTRICT="strip binchecks"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/${MY_P}"

DOCS="readme.txt"
FONT_CONF=( "${FILESDIR}"/60-aquapfont.conf )
FONT_S="${S}"
FONT_SUFFIX="ttf"

pkg_postinst() {
	font_pkg_postinst

	elog "To use aquapfont instead of the default font for sans and serif use:"
	elog "   eselect fontconfig enable 60-aquapfont.conf"
}
