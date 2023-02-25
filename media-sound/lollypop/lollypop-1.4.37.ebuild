# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="sqlite"
inherit python-single-r1 gnome2-utils meson xdg

DESCRIPTION="Modern music player for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Lollypop"
SRC_URI="https://adishatz.org/${PN}/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

# Dependencies being checked by Meson
DEPEND="
	dev-libs/glib:2
	dev-libs/gobject-introspection
	net-libs/libsoup:3.0[introspection]
	x11-libs/gtk+:3[introspection]
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
	')
"

BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
	test? (
		dev-libs/appstream-glib
		dev-util/desktop-file-utils
	)
"

RDEPEND="
	${DEPEND}
	media-plugins/gst-plugins-pulse
	app-crypt/libsecret[introspection]
	dev-libs/totem-pl-parser[introspection]
	gui-libs/libhandy:1[introspection]
	$(python_gen_cond_dep '
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/gst-python[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
	')
"

src_install() {
	meson_src_install
	python_optimize
	python_fix_shebang "${ED}/usr/bin"
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
	elog "Remember to install the necessary gst-plugins packages to read your audio files."
	elog "You can also use the gst-plugins-meta pakcage and its USE flags."
	elog "Lollypop now relies on yt-dlp instead of youtube-dl, since version 1.4.36."
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
