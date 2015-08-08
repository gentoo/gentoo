# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Bluetooth, infrared or cable remote control service"
HOMEPAGE="http://anyremote.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="avahi bluetooth dbus"

RDEPEND="
	dev-libs/glib:2
	x11-libs/libX11
	x11-libs/libXtst
	avahi? ( net-dns/avahi )
	bluetooth? ( net-wireless/bluez )
	dbus? (
		dev-libs/dbus-glib
		sys-apps/dbus
	)
"

DEPEND="${RDEPEND}
	virtual/pkgconfig
"

DOCS=( AUTHORS ChangeLog NEWS README )

src_configure() {
	econf \
		--docdir="/usr/share/doc/${PF}/" \
		$(use_enable avahi) \
		$(use_enable bluetooth) \
		$(use_enable dbus)
}

src_install() {
	default

	mv "${ED}"/usr/share/doc/${PF}/{doc-html,html} || die
}
