# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3

DESCRIPTION="NetworkManager WireGuard plugin"
HOMEPAGE="https://github.com/max-moser/network-manager-wireguard"
SRC_URI=""
EGIT_REPO_URI="https://github.com/max-moser/network-manager-wireguard"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+glib +gtk +nls"
REQUIRED_USE="glib? ( gtk )"

RDEPEND="
	net-misc/networkmanager
	net-vpn/wireguard-tools[wg-quick]
	glib? ( dev-libs/glib )
	gtk? (
		app-crypt/libsecret
		gnome-extra/nm-applet
		x11-libs/gtk+:3
	)
"

DEPEND="${RDEPEND}"

BDEPEND="
	virtual/pkgconfig
	nls? (
		dev-util/intltool
		sys-devel/gettext
	)
"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-lto
		--disable-more-warnings
		--disable-static
		$(use_with glib	libnm-glib)
		$(use_with gtk gnome)
		$(use_enable nls)
		--with-dist-version="Gentoo"
	)

	econf "${myeconfargs[@]}"
}
