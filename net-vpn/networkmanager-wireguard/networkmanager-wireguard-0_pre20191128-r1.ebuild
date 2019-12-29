# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

EGIT_COMMIT="0e1124df9e97129c5e0d9996a2c3876ae18f01c4"
MY_PN="${PN/network/network-}"

DESCRIPTION="NetworkManager WireGuard plugin"
HOMEPAGE="https://github.com/max-moser/network-manager-wireguard"
SRC_URI="https://github.com/max-moser/${MY_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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

S="${WORKDIR}/${MY_PN}-${EGIT_COMMIT}"

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
