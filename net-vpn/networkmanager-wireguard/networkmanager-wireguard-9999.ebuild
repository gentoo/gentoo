# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3

DESCRIPTION="NetworkManager WireGuard plugin"
HOMEPAGE="https://github.com/max-moser/network-manager-wireguard"
SRC_URI=""
EGIT_REPO_URI="https://github.com/max-moser/network-manager-wireguard"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+gtk +nls"

RDEPEND="
	>=net-misc/networkmanager-1.7.0
	net-vpn/wireguard-tools[wg-quick]
	>=dev-libs/glib-2.32:2
	gtk? (
		>=x11-libs/gtk+-3.4:3
		>=net-libs/libnma-1.7.0
		>=app-crypt/libsecret-0.18
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

PATCHES="${FILESDIR}/${PN}-0_pre20191128-change-appdata-path.patch"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-lto
		--disable-more-warnings
		--disable-static
		$(use_with gtk gnome)
		--without-libnm-glib
		$(use_enable nls)
		--with-dist-version="Gentoo"
	)

	econf "${myeconfargs[@]}"
}
