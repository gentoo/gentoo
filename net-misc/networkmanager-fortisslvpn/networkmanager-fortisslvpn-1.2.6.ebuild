# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME_ORG_MODULE="NetworkManager-${PN##*-}"
GNOME2_LA_PUNT="yes"
GNOME2_EAUTORECONF="yes"

inherit gnome2

DESCRIPTION="NetworkManager Fortinet SSLVPN compatible plugin"
HOMEPAGE="https://wiki.gnome.org/Projects/NetworkManager"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gtk"

RDEPEND="
	>=net-misc/networkmanager-1.2:=
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

PATCHES=(
	# Upstream patch e5d476076e068f58ef4fa938f09945159fce36a6
	"${FILESDIR}"/${P}-location-fix.diff
	# Upstream patch 4195187fbe5be348222c9a8472f7c9cf0e51d346
	"${FILESDIR}"/${P}-nm-utils-dependency-fix.diff
)

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--with-dist-version=Gentoo \
		--localstatedir=/var \
		$(use_with gtk gnome)
}
