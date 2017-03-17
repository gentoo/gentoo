# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="no"
GNOME_ORG_MODULE="NetworkManager-${PN##*-}"

inherit gnome2

DESCRIPTION="NetworkManager Openswan plugin"
HOMEPAGE="https://wiki.gnome.org/Projects/NetworkManager"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gtk"

RDEPEND="
	>=dev-libs/glib-2.32:2
	>=dev-libs/libnl-3.2.8:3
	>=net-misc/networkmanager-0.9.10:=
	>=dev-libs/dbus-glib-0.74
	|| ( net-misc/openswan net-vpn/libreswan )
	gtk? (
		app-crypt/libsecret
		>=gnome-extra/nm-applet-0.9.10
		>=x11-libs/gtk+-3.4:3
	)
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/intltool
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure \
		--disable-more-warnings \
		--disable-static \
		--with-dist-version=Gentoo \
		$(use_with gtk gnome)
}
