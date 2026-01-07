# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2

DESCRIPTION="Library and layout configuration for the Desktop Menu fd.o specification"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-menus"

LICENSE="GPL-2+ LGPL-2+"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="+introspection test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.80.0:2
	introspection? ( >=dev-libs/gobject-introspection-1.82.0-r2:= )
"
DEPEND="${RDEPEND}
	test? ( dev-libs/gjs )
"
BDEPEND="
	>=sys-devel/gettext-0.19.4
	virtual/pkgconfig
"

DOCS=( AUTHORS ChangeLog HACKING NEWS README )

src_configure() {
	# Do NOT compile with --disable-debug/--enable-debug=no
	# It disables api usage checks
	gnome2_src_configure $(use_enable introspection)
}
