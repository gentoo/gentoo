# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME_ORG_MODULE="NetworkManager-${PN##*-}"

inherit gnome2 autotools

DESCRIPTION="NetworkManager Fortinet SSLVPN compatible plugin"
HOMEPAGE="https://wiki.gnome.org/Projects/NetworkManager"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gtk"

RDEPEND="
	>=net-misc/networkmanager-1.1:=
	>=dev-libs/glib-2.32:2
	net-dialup/ppp:=
	>=net-vpn/openfortivpn-1.2.0
	gtk? (
		>=app-crypt/libsecret-0.18
		>=gnome-extra/nm-applet-1.2.0
		>=x11-libs/gtk+-3.4:3
	)
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	virtual/pkgconfig
"

src_prepare() {
	# Upstream patch 377ba9ca7fb33f3fb2ba5258a5af666869947597
	eapply "${FILESDIR}/${P}-location-fix.diff"

	eapply_user

	eautoreconf

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--with-dist-version=Gentoo \
		--localstatedir=/var \
		$(use_with gtk gnome)
}
