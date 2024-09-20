# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Tray menu for the Fluxbox toolbar"
HOMEPAGE="https://ftmenu.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2"
RDEPEND="
	${DEPEND}
	x11-wm/fluxbox"
BDEPEND="virtual/pkgconfig"

pkg_postinst() {
	einfo
	einfo "To use ftmenu, edit your ~/.fluxbox/menu file and modify the [begin]"
	einfo "line to contain the path to an icon of your choice."
	einfo
	einfo "For example, to use the default ftmenu xpm icon:"
	einfo "   [begin] (Fluxbox-0.9.12) </usr/share/ftmenu/fb.xpm>"
	einfo
	einfo "Next, add 'ftmenu &' to your X startup file (~/.xinitrc or ~/.xsession)."
	einfo
}
