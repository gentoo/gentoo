# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Shiki-Colors mixes the elegance of a dark theme with the usability of a light theme"
HOMEPAGE="https://code.google.com/p/gnome-colors/"

SRC_URI="https://gnome-colors.googlecode.com/files/${P}.tar.gz
	https://dev.gentoo.org/~pacho/Shiki-Gentoo-${PV}.tar.bz2"

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
