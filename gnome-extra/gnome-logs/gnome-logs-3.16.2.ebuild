# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-logs/gnome-logs-3.16.2.ebuild,v 1.1 2015/06/09 16:12:35 eva Exp $

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Log messages and event viewer"
HOMEPAGE="https://wiki.gnome.org/Apps/Logs"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.43.90:2
	sys-apps/systemd
	>=x11-libs/gtk+-3.15.7:3
"
DEPEND="${RDEPEND}
	~app-text/docbook-xml-dtd-4.3
	dev-libs/appstream-glib
	dev-libs/libxslt
	>=dev-util/intltool-0.50
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure ITSTOOL="$(type -P true)"
}
