# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2

DESCRIPTION="Nibbles clone for Gnome"
HOMEPAGE="https://wiki.gnome.org/Apps/Nibbles"

LICENSE="GPL-3+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.40.0:2
	dev-libs/libgee:0.8=
	dev-libs/libgnome-games-support:1=
	>=media-libs/clutter-1.22.0:1.0
	>=media-libs/clutter-gtk-1.4.0:1.0
	>=media-libs/libcanberra-0.26[gtk3]
	>=x11-libs/gtk+-3.18.0:3
"
DEPEND="${RDEPEND}
	dev-libs/appstream-glib
	>=dev-util/intltool-0.50.2
	dev-util/itstool
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure VALAC="$(type -P true)"
}
