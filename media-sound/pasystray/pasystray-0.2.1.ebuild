# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/pasystray/pasystray-0.2.1.ebuild,v 1.2 2014/10/12 17:28:06 pacho Exp $

EAPI=4
inherit gnome2-utils

DESCRIPTION="A system tray for pulseaudio controls (replacement for the deprecated padevchooser)"
HOMEPAGE="http://github.com/christophgysin/pasystray"
SRC_URI="mirror://github/christophgysin/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libnotify"

RDEPEND="
	|| ( >=media-sound/pulseaudio-1.0[glib,avahi] >=media-sound/pulseaudio-5.0-r3[glib,zeroconf] )
	>=net-dns/avahi-0.6
	x11-libs/gtk+:3
	x11-libs/libX11
	libnotify? ( >=x11-libs/libnotify-0.7 )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="AUTHORS README TODO"

src_configure() {
	econf $(use_enable libnotify notify)
}

pkg_preinst() {	gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
