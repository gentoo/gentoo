# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=${P/-fonts/}
inherit font

DESCRIPTION="Vietnamese version of the standard PostScript fonts from URW++"
# Check updates on:
# http://vntex.sourceforge.net/fonts/urwvn-ttf/download/
# https://sourceforge.net/projects/vntex/files
HOMEPAGE="http://vntex.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/vntex/urwvn-ttf/${MY_P}-ttf.tar.bz2"
S="${WORKDIR}/${MY_P}-ttf"

LICENSE="GPL-2 Aladdin" # bug #434262
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ppc s390 sparc x86"
IUSE=""

FONT_CONF=( "${FILESDIR}/65-urwvn.conf" )
FONT_SUFFIX="ttf"

pkg_postinst() {
	font_pkg_postinst
	ewarn 'For legal reasons "Vn Utopia" font was renamed to "Vntopia".'
	ewarn 'If you configured some programs to use "Vn Utopia", please,'
	ewarn 'enable aliases (65-urwvn.conf) with `eselect fontconfig`.'
}
