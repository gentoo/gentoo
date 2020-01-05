# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_6 )

inherit meson eutils gnome2 python-single-r1

DESCRIPTION="A collection of libraries and utilites used by Cinnamon"
HOMEPAGE="http://developer.linuxmint.com/projects/cinnamon-projects.html"
SRC_URI="https://github.com/linuxmint/cinnamon-desktop/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ FDL-1.1+ LGPL-2+"
SLOT="0/4" # subslot = libcinnamon-desktop soname version
KEYWORDS="~amd64 ~x86"
IUSE="+introspection systemd"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.37.3:2[dbus]
	media-sound/pulseaudio[glib]
	>=x11-libs/gdk-pixbuf-2.22:2[introspection?]
	>=x11-libs/gtk+-3.3.16:3[introspection?]
	>=x11-libs/libXext-1.1
	>=x11-libs/libXrandr-1.3
	x11-libs/cairo:=[X]
	x11-libs/libX11
	x11-libs/libxkbfile
	x11-misc/xkeyboard-config
	>=gnome-base/gsettings-desktop-schemas-3.5.91
	introspection? ( >=dev-libs/gobject-introspection-0.9.7:= )
	sys-apps/accountsservice
"
RDEPEND="${COMMON_DEPEND}
	dev-python/pygobject:3[${PYTHON_USEDEP}]
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/gtk-doc-am-1.4
	>=dev-util/intltool-0.40.6
	gnome-base/gnome-common
	x11-base/xorg-proto
	virtual/pkgconfig
"

pkg_setup() {
	python_setup
}

src_configure() {
	meson_src_configure
}

src_install() {
	meson_src_install

	# set sane default gschema values for systemd users
	if use systemd; then
		insinto /usr/share/glib-2.0/schemas/
		newins "${FILESDIR}"/${PN}-2.6.4.systemd.gschema.override ${PN}.systemd.gschema.override
	fi
}
