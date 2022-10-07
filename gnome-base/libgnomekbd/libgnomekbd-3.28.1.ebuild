# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson

DESCRIPTION="Gnome keyboard configuration library"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libgnomekbd"

LICENSE="LGPL-2+"
SLOT="0/8"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="+introspection"

RDEPEND="
	>=dev-libs/glib-2.44.0:2
	>=x11-libs/gtk+-2.91.7:3[X,introspection?]
	x11-libs/libX11
	>=x11-libs/libxklavier-5.2:=[introspection?]

	introspection? ( >=dev-libs/gobject-introspection-0.6.7:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.6
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_use introspection)
		-Dvapi=false # will add USE=vala if there's a reverse dependency
		-Dtests=false # Controls building test programs that are not installed
	)
	meson_src_configure
}
