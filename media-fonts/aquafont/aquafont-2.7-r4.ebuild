# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/aquafont/aquafont-2.7-r4.ebuild,v 1.6 2010/02/21 02:14:12 abcd Exp $

inherit font

MY_P="${PN/font/}${PV/\./_}"

DESCRIPTION="Handwritten Japanese fixed-width TrueType font"
HOMEPAGE="http://www.geocities.jp/teardrops_in_aquablue/"
SRC_URI="http://www.geocities.jp/teardrops_in_aquablue/fnt/${MY_P}.zip"

LICENSE="aquafont"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="X"

S="${WORKDIR}/${MY_P}"
FONT_S="${S}"
FONT_SUFFIX="ttf"

DEPEND="app-arch/unzip"
RDEPEND=""

DOCS="readme.txt"

# Only installs fonts
RESTRICT="strip binchecks"

FONT_CONF=( "${FILESDIR}/60-aquafont.conf" )

pkg_postinst() {
	font_pkg_postinst

	echo
	elog "To use aquafont instead of the default font for monospace use:"
	elog "   eselect fontconfig enable 60-aquafont.conf"
	echo
}
