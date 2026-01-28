# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit meson flag-o-matic gnome2-utils python-any-r1

DESCRIPTION="A collection of libraries and utilites used by Cinnamon"
HOMEPAGE="https://projects.linuxmint.com/cinnamon/ https://github.com/linuxmint/cinnamon-desktop"
SRC_URI="https://github.com/linuxmint/cinnamon-desktop/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-1 GPL-2+ LGPL-2+ LGPL-2.1+ MIT"
SLOT="0/4" # subslot = libcinnamon-desktop soname version
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="wayland"

DEPEND="
	app-text/iso-codes
	>=dev-libs/glib-2.37.3:2[dbus]
	>=dev-libs/gobject-introspection-1.82.0-r2:=
	>=gnome-base/gsettings-desktop-schemas-3.5.91
	>=media-libs/libpulse-12.99.3[glib]
	virtual/libudev:=
	x11-libs/cairo[X]
	>=x11-libs/gdk-pixbuf-2.22:2[introspection]
	>=x11-libs/gtk+-3.3.16:3[introspection,wayland?,X]
	x11-libs/libX11
	>=x11-libs/libXext-1.1
	x11-libs/libxkbfile
	>=x11-libs/libXrandr-1.3
	x11-base/xorg-proto
	x11-misc/xkeyboard-config
"
RDEPEND="
	${DEPEND}
	sys-apps/accountsservice
	x11-themes/xapp-symbolic-icon-theme
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-util/gdbus-codegen-2.80.5-r1
	dev-util/glib-utils
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	default
	python_fix_shebang install-scripts
}

src_configure() {
	# defang automagic dependencies
	# Preliminary wayland support only. Xorg code is unconditional.
	use wayland || append-cflags -DGENTOO_GTK_HIDE_WAYLAND

	local emesonargs=(
		# https://github.com/linuxmint/cinnamon-desktop/commit/7eadfb1da9a42384396978b8ab46e0725d18e04f
		# > Unless/until this fixes an actual identified issue for us or provides significant advantages
		# > we're not using it in Cinnamon.
		-Dsystemd=disabled
	)
	meson_src_configure
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
