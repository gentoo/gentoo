# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic gnome2

DESCRIPTION="A library that provides top functionality to applications"
HOMEPAGE="https://git.gnome.org/browse/libgtop"

LICENSE="GPL-2+"
SLOT="2/11" # libgtop soname version
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 sparc x86"
IUSE="+introspection"

RDEPEND="
	>=dev-libs/glib-2.26:2
	introspection? ( >=dev-libs/gobject-introspection-0.6.7:= )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.4
	>=sys-devel/gettext-0.19.4
	virtual/pkgconfig
"

src_configure() {
	# Add explicit stdc, bug #628256
	append-cflags "-std=c99"

	gnome2_src_configure \
		--disable-static \
		$(use_enable introspection)
}
