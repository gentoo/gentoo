# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit gnome2-utils

DESCRIPTION="A simple locker using lightdm"
HOMEPAGE="https://github.com/the-cavalry/light-locker"
SRC_URI="${HOMEPAGE}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+consolekit +dpms gtk3 +screensaver -systemd +upower"

RDEPEND="dev-libs/dbus-glib
	>=dev-libs/glib-2.25.6:2
	>=sys-apps/dbus-0.30
	x11-libs/cairo
	x11-libs/libX11
	x11-libs/pango
	x11-libs/libXxf86vm
	consolekit? ( sys-auth/consolekit )
	dpms? ( x11-libs/libXext )
	!gtk3? ( >=x11-libs/gtk+-2.24:2 )
	gtk3? ( x11-libs/gtk+:3 )
	screensaver? ( x11-libs/libXScrnSaver )
	systemd? ( sys-apps/systemd )
	upower? ( || ( sys-power/upower sys-power/upower-pm-utils ) )"
DEPEND="${RDEPEND}
	dev-lang/perl
	dev-perl/XML-Parser
	dev-util/intltool
	sys-devel/gettext"
RDEPEND="${RDEPEND}
	x11-misc/lightdm"

DOCS=( AUTHORS HACKING NEWS README )

src_prepare() {
	# Not using debian's patch on configure.ac because it requires running xdg-autogen which is a mess
	epatch "${FILESDIR}/${PN}-${PV}-systemd.patch"
	eapply_user
}

src_configure() {
	econf \
		$(use_with consolekit console-kit) \
		$(use_with dpms dpms-ext) \
		$(use_with !gtk3 gtk2) \
		$(use_with screensaver x) \
		$(use_with screensaver mit-ext) \
		$(use_with systemd) \
		$(use_with upower)
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
