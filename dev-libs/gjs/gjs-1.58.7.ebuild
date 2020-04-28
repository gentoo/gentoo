# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2 pax-utils virtualx

DESCRIPTION="Javascript bindings for GNOME"
HOMEPAGE="https://wiki.gnome.org/Projects/Gjs"

LICENSE="MIT || ( MPL-1.1 LGPL-2+ GPL-2+ )"
SLOT="0"
IUSE="+cairo examples gtk readline +sysprof test"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	>=dev-libs/glib-2.58.0
	>=dev-libs/gobject-introspection-1.61.2:=

	readline? ( sys-libs/readline:0= )
	dev-lang/spidermonkey:60
	dev-libs/libffi:=
	cairo? ( x11-libs/cairo[X] )
"
DEPEND="${RDEPEND}
	sysprof? ( >=dev-util/sysprof-capture-3.33.2:3 )
	virtual/pkgconfig
	test? ( sys-apps/dbus
		>=x11-libs/gtk+-3.20:3[introspection] )
"

RESTRICT="!test? ( test )"

src_configure() {
	# FIXME: add systemtap/dtrace support, like in glib:2
	# FIXME: --enable-systemtap installs files in ${D}/${D} for some reason
	# XXX: Do NOT enable coverage, completely useless for portage installs
	gnome2_src_configure \
		--disable-systemtap \
		--disable-dtrace \
		--disable-code-coverage \
		$(use_with cairo cairo) \
		$(use_enable sysprof profiler) \
		$(use_enable readline) \
		$(use_with test dbus-tests) \
		$(use_with test gtk-tests) \
		--disable-installed-tests
}

src_install() {
	# installation sometimes fails in parallel, bug #???
	gnome2_src_install -j1

	if use examples; then
		insinto /usr/share/doc/"${PF}"/examples
		doins "${S}"/examples/*
	fi

	# Required for gjs-console to run correctly on PaX systems
	pax-mark mr "${ED}/usr/bin/gjs-console"
}

src_test() {
	virtx emake check
}
