# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{5,6} )

inherit gnome.org gnome2-utils meson python-single-r1 xdg

DESCRIPTION="Music management for Gnome"
HOMEPAGE="https://wiki.gnome.org/Apps/Music"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

KEYWORDS="~amd64 ~x86"

# At 3.30.2 libdazzle only used from .ui file, thus introspection not needed
COMMON_DEPEND="${PYTHON_DEPS}
	net-libs/gnome-online-accounts[introspection]
	>=dev-libs/gobject-introspection-1.54:=
	>=x11-libs/gtk+-3.19.3:3[introspection]
	>=dev-libs/libdazzle-3.28.0
	>=media-libs/libmediaart-1.9.1:2.0[introspection]
	net-libs/libsoup:2.4[introspection]
	>=app-misc/tracker-1.99.1:=[introspection(+)]
	>=dev-python/pygobject-3.29.1:3[cairo,${PYTHON_USEDEP}]
	>=dev-python/pycairo-1.14.0[${PYTHON_USEDEP}]
	>=media-libs/grilo-0.3.4:0.3[introspection]
	>=media-plugins/grilo-plugins-0.3.8:0.3
"
# xdg-user-dirs-update needs to be there to create needed dirs
# https://bugzilla.gnome.org/show_bug.cgi?id=731613
RDEPEND="${COMMON_DEPEND}
	|| (
		>=app-misc/tracker-miners-1.99.1[gstreamer]
		>=app-misc/tracker-miners-1.99.1[ffmpeg]
	)
	x11-libs/libnotify[introspection]
	media-libs/gstreamer:1.0[introspection]
	media-libs/gst-plugins-base:1.0[introspection]
	media-plugins/gst-plugins-meta:1.0
	media-plugins/grilo-plugins:0.3[tracker]
	x11-misc/xdg-user-dirs
"
DEPEND="${COMMON_DEPEND}
	dev-libs/libxml2:2
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

pkg_setup() {
	python_setup
}

src_prepare() {
	sed -e '/sys.path.insert/d' -i "${S}"/gnome-music.in || die "python fixup sed failed"
	xdg_src_prepare
}

src_install() {
	meson_src_install
	python_fix_shebang "${D}"usr/bin/gnome-music
	python_optimize
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
