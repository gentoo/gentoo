# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2

DESCRIPTION="Logic puzzle game for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Hitori"

LICENSE="GPL-3+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE=""

# gtk+-3.22 for build-time optional gtk_show_uri_on_window usage
RDEPEND="
	>=dev-libs/glib-2.32:2
	>=x11-libs/gtk+-3.22:3
	>=x11-libs/cairo-1.4
"
DEPEND="${RDEPEND}
	dev-libs/appstream-glib
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"
