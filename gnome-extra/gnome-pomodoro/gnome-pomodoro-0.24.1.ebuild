# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2-utils meson vala virtualx xdg

DESCRIPTION="A time management utility for GNOME based on the pomodoro technique"
HOMEPAGE="http://gnomepomodoro.org https://github.com/gnome-pomodoro/gnome-pomodoro"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-libs/glib-2.38.0:2
	>=x11-libs/gtk+-3.20:3
	x11-libs/gdk-pixbuf:2[introspection]
	x11-libs/cairo
	dev-libs/gobject-introspection
	>=dev-libs/libpeas-1.5.0:0
	>=dev-libs/gom-0.3
	>=media-libs/gstreamer-1.0.10:1.0[introspection]
	>=media-libs/libcanberra-0.30
	>=dev-libs/json-glib-1.6.2[introspection]
	dev-db/sqlite:3
"
RDEPEND="${DEPEND}"
BDEPEND="
	$(vala_depend)
	dev-libs/glib
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	default

	# This function overrides GSETTINGS_SCHEMA_DIR which breaks the test
	sed -i -e '/this.setup_settings/d' tests/tests.vala || die

	vala_setup
	xdg_environment_reset
}

src_test() {
	local -x GSETTINGS_BACKEND="memory"
	local -x GSETTINGS_SCHEMA_DIR="${S}"/data
	"${BROOT}"${GLIB_COMPILE_SCHEMAS} --allow-any-name "${GSETTINGS_SCHEMA_DIR}" || die
	virtx meson_src_test
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
