# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/light-locker/light-locker-1.6.0.ebuild,v 1.2 2015/05/27 17:27:12 calchan Exp $

EAPI=5

inherit autotools-utils

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

src_configure() {
	local myeconfargs=(
		$(use_with consolekit console-kit)
		$(use_with dpms dpms-ext)
		$(use_with !gtk3 gtk2)
		$(use_with screensaver x)
		$(use_with screensaver mit-ext)
		$(use_with systemd)
		$(use_with upower)
	)
	autotools-utils_src_configure
}
