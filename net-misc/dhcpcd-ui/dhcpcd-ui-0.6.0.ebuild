# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/dhcpcd-ui/dhcpcd-ui-0.6.0.ebuild,v 1.1 2012/05/26 18:29:24 idl0r Exp $

EAPI=4

DESCRIPTION="Desktop notification and configuration for dhcpcd"
HOMEPAGE="http://roy.marples.name/projects/dhcpcd-ui/"
SRC_URI="http://roy.marples.name/downloads/dhcpcd/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="startup-notification"

DEPEND="sys-apps/dbus
	x11-libs/gtk+:2
	x11-libs/gdk-pixbuf
	dev-libs/glib:2
	startup-notification? ( >=x11-libs/libnotify-0.4.4 )"
RDEPEND="${DEPEND}
	net-libs/dhcpcd-dbus
	x11-themes/hicolor-icon-theme"

src_configure() {
	# Only GTK+ UI supported atm
	econf --with-gtk \
		$(use_enable startup-notification notification)
}
