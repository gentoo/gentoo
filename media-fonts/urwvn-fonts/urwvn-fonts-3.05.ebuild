# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit font

MY_P=${P/_/-}
MY_P=${MY_P/-fonts/}
DESCRIPTION="fonts gpl'd by Han The Thanh, based on URW++ fonts with Vietnamese glyphs added"
# Check updates on:
# http://vntex.sf.net/fonts/urwvn-ttf/download
# https://sourceforge.net/projects/vntex/files
HOMEPAGE="http://vntex.sf.net"
SRC_URI="mirror://sourceforge/project/vntex/urwvn-ttf/${MY_P}-ttf.tar.bz2"

LICENSE="GPL-2 Aladdin" # see bug #434262
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc s390 sh sparc x86 ~x86-fbsd"
IUSE=""

S="${WORKDIR}/${MY_P}-ttf"
FONT_SUFFIX="ttf"
FONT_S=${S}
FONT_CONF=( "${FILESDIR}/65-urwvn.conf" )

pkg_postinst() {
	font_pkg_postinst
	ewarn 'For legal reasons "Vn Utopia" font was renamed to "Vntopia".'
	ewarn 'If you configured some programs to use "Vn Utopia", please,'
	ewarn 'enable aliases (65-urwvn.conf) with `eselect fontconfig`.'
}
