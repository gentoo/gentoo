# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )

inherit flag-o-matic meson pax-utils python-any-r1 virtualx

DESCRIPTION="Linux Mint's fork of gjs for Cinnamon"
HOMEPAGE="https://projects.linuxmint.com/cinnamon/ https://github.com/linuxmint/cjs"
SRC_URI="https://github.com/linuxmint/cjs/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD CC0-1.0 MIT MPL-2.0 || ( MPL-1.1 GPL-2+ LGPL-2.1+ )"
SLOT="0"
IUSE="+cairo examples readline sysprof test"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND="
	dev-lang/spidermonkey:102
	>=dev-libs/glib-2.66.0:2
	>=dev-libs/gobject-introspection-1.71.0:=
	>=dev-libs/libffi-3.3:0=

	cairo? (
		x11-libs/cairo[glib,svg(+),X]
		x11-libs/libX11
	)
	readline? ( sys-libs/readline:0= )
"
DEPEND="
	${RDEPEND}
	sysprof? ( >=dev-util/sysprof-capture-3.40.1:4 )
	test? (
		sys-apps/dbus
		x11-libs/gtk+:3[introspection]
	)
"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-5.8.0-move_have_gtk4_to_the_appropriate_place.patch
)

src_prepare() {
	default
	python_fix_shebang build
}

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

src_install() {
	meson_src_install

	if use examples; then
		docinto examples
		dodoc "${S}"/examples/*
	fi

	# Required for cjs-console to run correctly on PaX systems
	pax-mark mr "${ED}/usr/bin/cjs-console"
}
