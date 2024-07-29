# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Mixes the elegance of a dark theme with the usability of a light theme"
HOMEPAGE="https://code.google.com/p/gnome-colors/"
SRC_URI="https://gnome-colors.googlecode.com/files/${P}.tar.gz
	https://dev.gentoo.org/~pacho/Shiki-Gentoo-${PV}.tar.bz2"
S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	|| ( x11-wm/muffin x11-wm/mutter xfce-base/xfwm4 )
	x11-themes/gtk-engines:2
"
RESTRICT="binchecks strip"

src_install() {
	insinto /usr/share/themes
	doins -r "${WORKDIR}"/Shiki*
	dodoc AUTHORS ChangeLog README
}
