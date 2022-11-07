# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GNOME_ORG_MODULE="NetworkManager-${PN##*-}"

inherit gnome2

DESCRIPTION="NetworkManager OpenVPN plugin"
HOMEPAGE="https://gitlab.gnome.org/GNOME/NetworkManager-openvpn https://gitlab.gnome.org/GNOME/NetworkManager-openvpn"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86"
IUSE="gtk test"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-libs/glib-2.34:2
	dev-libs/libxml2:2
	>=net-misc/networkmanager-1.7.0:=
	>=net-vpn/openvpn-2.1
	gtk? (
		>=app-crypt/libsecret-0.18

		>=net-libs/libnma-1.8.0
		>=x11-libs/gtk+-3.4:3

		>=gui-libs/gtk-4.0:4
		>=net-libs/libnma-1.8.36
	)
"

RDEPEND="
	${DEPEND}
	acct-group/nm-openvpn
	acct-user/nm-openvpn
"

BDEPEND="
	>=sys-devel/gettext-0.19
	virtual/pkgconfig
"

src_configure() {
	# --localstatedir=/var needed per bug #536248
	gnome2_src_configure \
		--localstatedir=/var \
		--disable-more-warnings \
		--disable-static \
		--with-dist-version=Gentoo \
		$(use_with gtk gnome) \
		$(use_with gtk gtk4)
}
