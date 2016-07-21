# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools gnome2

DESCRIPTION="Gnome and XFCE applet for displaying XMonad log"
HOMEPAGE="https://github.com/alexkay/xmonad-log-applet"
SRC_URI="mirror://github/alexkay/${PN}/${P}.tar.gz"
LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="mirror"

RDEPEND="
	sys-apps/dbus
	xfce-base/xfce4-panel
	dev-libs/glib:2
	dev-haskell/dbus
	x11-libs/gtk+:3
"
DEPEND="${RDEPEND}"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf --sysconfdir=/etc --with-panel=xfce4
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS.md README.md
	dodoc "${FILESDIR}"/xmonad.hs
}

pkg_postinst() {
	elog "Remember to update your xmonad.hs accordingly"
	elog "a sample xmonad.hs is provided in /usr/share/doc/${PF}"
}
