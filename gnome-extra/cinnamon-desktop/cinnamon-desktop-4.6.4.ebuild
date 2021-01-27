# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8} )

inherit meson gnome2-utils python-any-r1

DESCRIPTION="A collection of libraries and utilites used by Cinnamon"
HOMEPAGE="https://projects.linuxmint.com/cinnamon/"
SRC_URI="https://github.com/linuxmint/cinnamon-desktop/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ FDL-1.1+ LGPL-2+"
SLOT="0/4" # subslot = libcinnamon-desktop soname version
KEYWORDS="amd64 ~arm64 x86"

COMMON_DEPEND="
	>=dev-libs/glib-2.37.3:2[dbus]
	media-sound/pulseaudio[glib]
	>=x11-libs/gdk-pixbuf-2.22:2[introspection]
	>=dev-libs/gobject-introspection-0.10.2:=
	>=x11-libs/gtk+-3.3.16:3[introspection]
	>=x11-libs/libXext-1.1
	>=x11-libs/libXrandr-1.3
	x11-libs/cairo:=[X]
	x11-libs/libX11
	x11-libs/libxkbfile
	x11-misc/xkeyboard-config
	>=gnome-base/gsettings-desktop-schemas-3.5.91
	sys-apps/accountsservice
"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto
"
BDEPEND="${PYTHON_DEPS}
	dev-util/glib-utils
	>=dev-util/intltool-0.40.6
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
