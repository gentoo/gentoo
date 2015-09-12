# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"

inherit autotools eutils gnome2

DESCRIPTION="Cinnamon session manager"
HOMEPAGE="http://cinnamon.linuxmint.com/"
SRC_URI="https://github.com/linuxmint/cinnamon-session/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ FDL-1.1+ LGPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
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
	systemd? ( >=sys-apps/systemd-183 )
	!systemd? ( >=sys-power/upower-pm-utils-0.9.23 )
"
RDEPEND="${COMMON_DEPEND}
	>=gnome-extra/cinnamon-desktop-2.6[systemd=]
	!systemd? ( sys-auth/consolekit )
"
DEPEND="${COMMON_DEPEND}
	dev-libs/libxslt
	>=dev-util/intltool-0.40.6
	virtual/pkgconfig
	doc? ( app-text/xmlto )

	gnome-base/gnome-common
"
#	gnome-base/gnome-common for eautoreconf

src_prepare() {
	# make upower and logind check non-automagic
	epatch "${FILESDIR}/${PN}-2.6.2-automagic.patch"
	epatch_user

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS README README.md"

	gnome2_src_configure \
		--disable-gconf \
		--disable-static \
		$(use_enable doc docbook-docs) \
		$(use_enable ipv6) \
		$(use_enable systemd logind) \
		$(usex systemd --disable-old-upower --enable-old-upower)
}
