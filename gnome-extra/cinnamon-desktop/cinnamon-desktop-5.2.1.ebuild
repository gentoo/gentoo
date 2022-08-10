# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9,10} )

inherit meson gnome2-utils python-any-r1

DESCRIPTION="A collection of libraries and utilites used by Cinnamon"
HOMEPAGE="https://projects.linuxmint.com/cinnamon/ https://github.com/linuxmint/cinnamon-desktop"
SRC_URI="https://github.com/linuxmint/cinnamon-desktop/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-1 GPL-2+ LGPL-2+ LGPL-2.1+ MIT"
SLOT="0/4" # subslot = libcinnamon-desktop soname version
KEYWORDS="amd64 ~arm64 ~riscv x86"

RDEPEND="
	>=dev-libs/glib-2.37.3:2[dbus]
	>=dev-libs/gobject-introspection-0.10.2:=
	>=gnome-base/gsettings-desktop-schemas-3.5.91
	media-sound/pulseaudio[glib]
	sys-apps/accountsservice
	x11-libs/cairo:=[X]
	>=x11-libs/gdk-pixbuf-2.22:2[introspection]
	>=x11-libs/gtk+-3.3.16:3[introspection]
	x11-libs/libX11
	>=x11-libs/libXext-1.1
	x11-libs/libxkbfile
	>=x11-libs/libXrandr-1.3
	x11-misc/xkeyboard-config
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	${PYTHON_DEPS}
	dev-util/glib-utils
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	default
	python_fix_shebang install-scripts
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
