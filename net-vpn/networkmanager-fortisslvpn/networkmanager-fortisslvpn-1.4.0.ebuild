# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GNOME_ORG_MODULE="NetworkManager-${PN##*-}"
GNOME2_LA_PUNT="yes"
GNOME2_EAUTORECONF="yes"

inherit gnome2

DESCRIPTION="NetworkManager Fortinet SSLVPN compatible plugin"
HOMEPAGE="https://wiki.gnome.org/Projects/NetworkManager"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64"
IUSE="gtk"

DEPEND="
	>=dev-libs/glib-2.32:2
	>=net-misc/networkmanager-1.2:=
	gtk? (
		>=app-crypt/libsecret-0.18
		gui-libs/gtk:4
		media-libs/harfbuzz
		>=net-libs/libnma-1.2.0
		x11-libs/cairo
		x11-libs/gdk-pixbuf
		x11-libs/pango
	)
"
RDEPEND="${RDEPEND}
	net-dialup/ppp
	>=net-vpn/openfortivpn-1.2.0"
BDEPEND="dev-util/gdbus-codegen
	>=sys-devel/gettext-0.19
	virtual/pkgconfig"

src_prepare() {
	default

	# Fix deprecated location, #709450
	sed -i 's|/appdata|/metainfo|g' Makefile.{in,am} || die
}

src_configure() {
	CONFIG_SHELL="${BROOT}"/bin/bash gnome2_src_configure \
		--disable-static \
		--with-dist-version=Gentoo \
		--localstatedir=/var \
		$(use_with gtk gnome) \
		$(use_with gtk gtk4) \
		--without-libnm-glib
}
