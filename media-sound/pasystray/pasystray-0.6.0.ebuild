# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit gnome2-utils autotools

DESCRIPTION="PulseAudio system tray"
HOMEPAGE="https://github.com/christophgysin/pasystray"
SRC_URI="https://github.com/christophgysin/${PN}/archive/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libnotify"

RDEPEND="
	>=media-sound/pulseaudio-5.0-r3[glib,zeroconf]
	>=net-dns/avahi-0.6
	x11-libs/gtk+:3
	x11-libs/libX11
	libnotify? ( >=x11-libs/libnotify-0.7 )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="AUTHORS README.md TODO"
S=${WORKDIR}/${PN}-${P}

src_prepare() {
	eautoreconf
}
src_configure() {
	econf $(use_enable libnotify notify)
	sed -i -e 's:volume:volume;:' "data/pasystray.desktop"
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc ${DOCS}
	doman man/pasystray.1
}

pkg_preinst() {	gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
