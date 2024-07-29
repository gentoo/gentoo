# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit xdg meson gnome2-utils virtualx python-r1

DESCRIPTION="Pandora.com client for the GNOME desktop"
HOMEPAGE="https://pithos.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="appindicator +keybinder libnotify test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-python/pygobject[${PYTHON_USEDEP}]
	app-crypt/libsecret[introspection]
	dev-libs/appstream-glib[introspection]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pylast[${PYTHON_USEDEP}]
	media-libs/gstreamer:1.0[introspection]
	media-plugins/gst-plugins-meta:1.0[aac,http,mp3]
	x11-libs/gtk+:3[introspection]
	x11-libs/pango[introspection]
	x11-themes/hicolor-icon-theme
	appindicator? ( dev-libs/libdbusmenu[gtk3,introspection] )
	keybinder? ( dev-libs/keybinder:3[introspection] )
	libnotify? ( x11-libs/libnotify[introspection] )
"
BDEPEND="
	virtual/pkgconfig
	test? (
		${RDEPEND}
		dev-libs/glib:2
		dev-util/desktop-file-utils
	)
"

src_configure() {
	python_foreach_impl meson_src_configure
}

src_compile() {
	python_foreach_impl meson_src_compile
}

src_test() {
	virtx python_foreach_impl meson_src_test
}

src_install() {
	python_foreach_impl meson_src_install
	einstalldocs
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_pkg_postinst
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_pkg_postrm
}
