# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/shiki-colors/shiki-colors-4.6.ebuild,v 1.5 2014/10/13 15:34:52 pacho Exp $

EAPI=5

DESCRIPTION="Shiki-Colors mixes the elegance of a dark theme with the usability of a light theme"
HOMEPAGE="http://code.google.com/p/gnome-colors/"

SRC_URI="http://gnome-colors.googlecode.com/files/${P}.tar.gz
	http://dev.gentoo.org/~pacho/Shiki-Gentoo-${PV}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	|| ( x11-wm/metacity x11-wm/muffin x11-wm/mutter xfce-base/xfwm4 )
	x11-themes/gtk-engines:2
"
DEPEND=""
RESTRICT="binchecks strip"

S="${WORKDIR}/"

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	dodir /usr/share/themes
	insinto /usr/share/themes
	doins -r "${WORKDIR}"/Shiki*
	dodoc AUTHORS ChangeLog README
}
