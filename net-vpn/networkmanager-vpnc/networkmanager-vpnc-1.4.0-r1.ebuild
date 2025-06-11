# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GNOME_ORG_MODULE="NetworkManager-${PN##*-}"

inherit gnome2

DESCRIPTION="NetworkManager VPNC plugin"
HOMEPAGE="https://wiki.gnome.org/Projects/NetworkManager"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="gtk test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=net-misc/networkmanager-1.2.0:=
	>=dev-libs/glib-2.32:2
	>=net-vpn/vpnc-0.5.3_p550
	gtk? (
		>=x11-libs/gtk+-3.4:3

		>=app-crypt/libsecret-0.18

		>=gui-libs/gtk-4.0:4
		>=net-libs/libnma-1.8.36
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
		$(use_with gtk gnome) \
		$(use_with gtk gtk4)
}
