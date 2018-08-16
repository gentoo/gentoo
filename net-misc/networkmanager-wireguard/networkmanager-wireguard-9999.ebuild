# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="https://github.com/max-moser/network-manager-wireguard"

GNOME2_EAUTORECONF=yes

inherit gnome2 user git-r3

DESCRIPTION="NetworkManager WireGuard plugin"
HOMEPAGE="https://github.com/max-moser/network-manager-wireguard"
SRC_URI=""

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE="gtk test"

RDEPEND="
	>=dev-libs/glib-2.54:2
	>=net-misc/networkmanager-1.7.0:=
	net-vpn/wireguard
	gtk? (
		>=app-crypt/libsecret-0.18
		>=gnome-extra/nm-applet-1.7.0
		>=x11-libs/gtk+-3.4:3
	)
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	virtual/pkgconfig
"

src_unpack() {
	git-r3_src_unpack
}

src_configure() {
	# --localstatedir=/var needed per bug #536248
	gnome2_src_configure \
		--localstatedir=/var \
		--disable-more-warnings \
		--disable-static \
		--with-dist-version=Gentoo \
		$(use_with gtk gnome) \
		$(use_with gtk libnm-glib)
}
