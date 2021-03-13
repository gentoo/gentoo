# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org meson virtualx

DESCRIPTION="Javascript bindings for GNOME"
HOMEPAGE="https://wiki.gnome.org/Projects/Gjs"

LICENSE="MIT || ( MPL-1.1 LGPL-2+ GPL-2+ )"
SLOT="0"
IUSE="+cairo examples gtk readline sysprof test"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~x86"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.58.0
	dev-libs/libffi:=
	>=dev-libs/gobject-introspection-1.61.2:=
	dev-lang/spidermonkey:78
	cairo? ( x11-libs/cairo[X] )
	readline? ( sys-libs/readline:0= )
"
DEPEND="${RDEPEND}
	sysprof? ( >=dev-util/sysprof-capture-3.38.1:4 )
	test? ( sys-apps/dbus
		>=x11-libs/gtk+-3.20:3[introspection] )
"
BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	# FIXME: add systemtap/dtrace support, like in glib:2
	local emesonargs=(
		$(meson_feature cairo)
		$(meson_feature readline)
		$(meson_feature sysprof profiler)
		-Dinstalled_tests=false
		$(meson_use !test skip_dbus_tests)
		$(meson_use !test skip_gtk_tests)
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}
