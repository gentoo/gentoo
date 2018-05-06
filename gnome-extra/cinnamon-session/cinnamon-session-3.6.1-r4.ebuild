# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils gnome2

DESCRIPTION="Cinnamon session manager"
HOMEPAGE="http://cinnamon.linuxmint.com/"
SRC_URI="https://github.com/linuxmint/cinnamon-session/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ FDL-1.1+ LGPL-2+"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="doc ipv6 systemd"

COMMON_DEPEND="
	>=dev-libs/dbus-glib-0.88
	>=dev-libs/glib-2.37.3:2
	media-libs/libcanberra
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3:3
	x11-libs/cairo
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXcomposite
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/pango[X]
	virtual/opengl
	systemd? ( >=sys-apps/systemd-183
			   sys-auth/polkit )
	!systemd? ( sys-power/upower
			   sys-auth/polkit[elogind] )
"

RDEPEND="${COMMON_DEPEND}
	>=gnome-extra/cinnamon-desktop-2.6[systemd=]
	!systemd? ( sys-auth/elogind[policykit] )
"
DEPEND="${COMMON_DEPEND}
	dev-libs/libxslt
	>=dev-util/intltool-0.40.6
	virtual/pkgconfig
	doc? ( app-text/xmlto )

	gnome-base/gnome-common
"

src_prepare() {
	# make upower and logind check non-automagic
	eapply "${FILESDIR}/${PN}-3.0.1-automagic.patch"
	eapply "${FILESDIR}/${PN}-3.6.1-elogind.patch"
	eapply "${FILESDIR}/${PN}-3.6.1-elogind2.patch"

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-gconf \
		--disable-static \
		--enable-logind \
		$(use_enable doc docbook-docs) \
		$(use_enable ipv6)
}
