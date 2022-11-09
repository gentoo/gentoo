# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic gnome.org meson virtualx

DESCRIPTION="Javascript bindings for GNOME"
HOMEPAGE="https://wiki.gnome.org/Projects/Gjs https://gitlab.gnome.org/GNOME/gjs"

LICENSE="MIT || ( MPL-1.1 LGPL-2+ GPL-2+ )"
SLOT="0"
IUSE="+cairo examples readline sysprof test"
KEYWORDS="amd64 arm arm64 ppc64 ~riscv x86"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.66.0:2
	dev-libs/libffi:=
	>=dev-libs/gobject-introspection-1.66.1:=
	>=dev-lang/spidermonkey-91.3.0:91
	cairo? ( x11-libs/cairo[X,glib,svg(+)] )
	readline? ( sys-libs/readline:0= )
"
DEPEND="${RDEPEND}
	sysprof? ( >=dev-util/sysprof-capture-3.40.1:4 )
	test? (
		sys-apps/dbus
		>=x11-libs/gtk+-3.20:3[introspection]
	)
"
BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	append-cppflags -DG_DISABLE_CAST_CHECKS

	# On musl, it's required that either gjs, pixman or gnome-shell to be built
	# with a larger stack otherwise librsvg fails to render a particular SVG, as
	# a result we fail to get gdm or gnome-shell running (greeted with a fail
	# whale screen). The bug has been reported to librsvg. This is ideally just
	# a temporary workaround until we understand what exactly needs a larger
	# stack size, as it's not sufficient to do just librsvg.
	#
	# Please refer to:
	# https://gitlab.gnome.org/GNOME/librsvg/-/issues/686
	# https://gitlab.gnome.org/GNOME/librsvg/-/issues/874
	#
	# TODO: Find an actual fix instead of increasing the stack
	use elibc_musl && append-ldflags -Wl,-z,stack-size=2097152

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
