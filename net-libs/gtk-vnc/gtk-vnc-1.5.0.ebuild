# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit flag-o-matic gnome.org vala meson python-any-r1 xdg

DESCRIPTION="VNC viewer widget for GTK"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gtk-vnc"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc x86"
IUSE="gtk-doc +introspection pulseaudio sasl +vala valgrind wayland X"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.56.0:2
	>=dev-libs/gmp-6.0.0:=
	>=x11-libs/gdk-pixbuf-2.36.0:2
	>=net-libs/gnutls-3.6.0:0=
	>=sys-libs/zlib-1.2.11
	>=x11-libs/gtk+-3.24.41-r1:3[introspection?,wayland?,X?]
	>=x11-libs/cairo-1.15.0
	elibc_musl? ( sys-libs/libucontext )
	introspection? ( >=dev-libs/gobject-introspection-1.56.0:= )
	pulseaudio? ( media-libs/libpulse )
	sasl? ( >=dev-libs/cyrus-sasl-2.1.27:2 )
	X? ( >=x11-libs/libX11-1.6.5 )
"
# Keymap databases code is generated with python3; configure picks up $PYTHON exported from python-any-r1_pkg_setup
# perl for pod2man
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
	valgrind? ( dev-debug/valgrind )
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-lang/perl-5
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	gtk-doc? ( dev-util/gi-docgen )
	vala? ( $(vala_depend) )
"

src_prepare() {
	default

	use vala && vala_setup
}

src_configure() {
	# defang automagic dependencies, bug #927952
	use wayland || append-cflags -DGENTOO_GTK_HIDE_WAYLAND
	use X || append-cflags -DGENTOO_GTK_HIDE_X11

	local emesonargs=(
		$(meson_feature gtk-doc gi-docs)
		$(meson_feature introspection)
		$(meson_feature pulseaudio)
		$(meson_feature sasl)
		-Dwith-coroutine=auto # gthread on windows, libc ucontext elsewhere; neither has extra deps
		$(meson_feature vala with-vala)
		$(meson_use valgrind)
	)
	meson_src_configure
}

src_test() {
	meson_src_test --no-suite style
}
