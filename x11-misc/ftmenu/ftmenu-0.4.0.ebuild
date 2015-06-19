# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/ftmenu/ftmenu-0.4.0.ebuild,v 1.3 2012/05/05 04:53:47 jdhore Exp $

EAPI="2"

DESCRIPTION="A tray menu for the Fluxbox toolbar"
HOMEPAGE="http://ftmenu.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

COMMON_DEPEND=">=x11-libs/gtk+-2.6:2
	>=dev-libs/glib-2.6:2"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}
	x11-wm/fluxbox"

src_compile() {
	emake CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS NEWS README ChangeLog || die
}

pkg_postinst() {
	echo
	einfo "To use ftmenu, edit your ~/.fluxbox/menu file and modify the [begin]"
	einfo "line to contain the path to an icon of your choice."
	einfo
	einfo "For example, to use the default ftmenu xpm icon:"
	einfo "   [begin] (Fluxbox-0.9.12) </usr/share/ftmenu/fb.xpm>"
	einfo
	einfo "Next, add 'ftmenu &' to your X startup file (~/.xinitrc or ~/.xsession)."
	echo
}
