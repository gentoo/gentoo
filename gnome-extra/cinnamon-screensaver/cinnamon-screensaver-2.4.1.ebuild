# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/cinnamon-screensaver/cinnamon-screensaver-2.4.1.ebuild,v 1.3 2015/03/15 13:24:20 pacho Exp $

EAPI="5"
GCONF_DEBUG="yes"

inherit autotools eutils gnome2

DESCRIPTION="Screensaver for Cinnamon"
HOMEPAGE="http://cinnamon.linuxmint.com/"
SRC_URI="https://github.com/linuxmint/cinnamon-screensaver/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
IUSE="doc pam systemd"
KEYWORDS="amd64 x86"

COMMON_DEPEND="
	>=dev-libs/glib-2.25.6:2
	>=x11-libs/gtk+-2.99.3:3
	>=gnome-extra/cinnamon-desktop-2.4:0=
	>=gnome-base/gsettings-desktop-schemas-0.1.7
	>=gnome-base/libgnomekbd-3.6
	>=dev-libs/dbus-glib-0.71

	sys-apps/dbus
	x11-libs/libxklavier
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrandr
	x11-libs/libXScrnSaver
	x11-libs/libXxf86misc
	x11-libs/libXxf86vm
	x11-themes/gnome-icon-theme-symbolic

	pam? ( virtual/pam )
	systemd? ( >=sys-apps/systemd-31:0= )
"
# our cinnamon-1.8 ebuilds installed a cinnamon-screensaver.desktop hack
RDEPEND="
	!~gnome-extra/cinnamon-1.8.8.1
	!systemd? ( sys-auth/consolekit )
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.35
	gnome-base/gnome-common
	sys-devel/gettext
	virtual/pkgconfig
	x11-proto/xextproto
	x11-proto/randrproto
	x11-proto/scrnsaverproto
	x11-proto/xf86miscproto
	doc? (
		app-text/xmlto
		app-text/docbook-xml-dtd:4.1.2
		app-text/docbook-xml-dtd:4.4 )
"

src_prepare() {
	# https://github.com/linuxmint/cinnamon-screensaver/issues/80
	sed -i -e 's/X-Cinnamon/X-Cinnamon;/' src/cinnamon-screensaver.desktop.in.in || die

	epatch_user
	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README"
	gnome2_src_configure \
		$(use_enable doc docbook-docs) \
		$(use_enable pam locking) \
		$(use_with systemd) \
		--with-mit-ext \
		--with-pam-prefix=/etc \
		--with-xf86gamma-ext \
		--with-kbd-layout-indicator
	# Do not use --without-console-kit, it would provide no benefit: there is
	# no build-time or run-time check for consolekit, $PN merely listens to
	# consolekit's messages over dbus.
}
