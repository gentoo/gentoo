# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome2

DESCRIPTION="A clean and friendly gtk-based serial terminal"
HOMEPAGE="https://wiki.gnome.org/Apps/Moserial https://gitlab.gnome.org/GNOME/moserial"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	>=dev-libs/glib-2.16:2[dbus]
	gnome-base/gsettings-desktop-schemas
	>=x11-libs/gtk+-3.2.0:3
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-util/intltool-0.35
	dev-util/itstool
	virtual/pkgconfig
"
