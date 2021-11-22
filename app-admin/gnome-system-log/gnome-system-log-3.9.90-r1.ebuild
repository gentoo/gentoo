# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2

DESCRIPTION="System log viewer for GNOME"
HOMEPAGE="https://wiki.gnome.org/Attic/GnomeUtils"

LICENSE="GPL-2+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"

DEPEND="
	>=dev-libs/glib-2.31:2
	sys-libs/zlib:=
	>=x11-libs/gtk+-3.9.11:3
	x11-libs/pango
"
RDEPEND="${DEPEND}
	gnome-base/gsettings-desktop-schemas"

BDEPEND="
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure \
		--enable-zlib \
		ITSTOOL=$(type -P true)
}
