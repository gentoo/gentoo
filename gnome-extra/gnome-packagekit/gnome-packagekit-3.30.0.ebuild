# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome.org gnome2-utils meson virtualx xdg

DESCRIPTION="PackageKit client for the GNOME desktop"
HOMEPAGE="https://www.freedesktop.org/software/PackageKit/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="systemd test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.32:2
	>=x11-libs/gtk+-3.15.3:3
	>=app-admin/packagekit-base-0.9.1
	systemd? (
		sys-auth/polkit
		>=sys-apps/systemd-42 )
"
DEPEND="${RDEPEND}
	app-text/docbook-sgml-utils
	app-text/docbook-sgml-dtd:4.1
	dev-libs/appstream-glib
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
"

# NOTES:
# app-text/docbook-sgml-utils and dtd required for man pages

# UPSTREAM:
# see if tests can forget about display (use eclass for that ?)

src_configure() {
	local emesonargs=(
		$(meson_use test tests)
		$(meson_use systemd)
	)
	meson_src_configure
}

src_test() {
	"${EROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/data" || die
	GSETTINGS_SCHEMA_DIR="${S}/data" virtx meson_src_test
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
	gnome2_icon_cache_update
}
