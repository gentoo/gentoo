# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson xdg virtualx

DESCRIPTION="GNOME webbrowser based on Webkit"
HOMEPAGE="https://apps.gnome.org/Epiphany/"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	>=x11-libs/cairo-1.2
	>=app-crypt/gcr-3.9.0:4=[gtk]
	>=x11-libs/gdk-pixbuf-2.36.5:2
	>=dev-libs/glib-2.74.0:2
	gnome-base/gsettings-desktop-schemas
	media-libs/gstreamer:1.0
	>=gui-libs/gtk-4.13.3:4
	>=app-text/iso-codes-0.35
	>=dev-libs/json-glib-1.6
	app-arch/libarchive:=
	>=gui-libs/libadwaita-1.6:1
	>=app-crypt/libsecret-0.19
	>=net-libs/libsoup-2.99.4:3.0
	>=dev-libs/libxml2-2.6.12:2=
	>=dev-libs/nettle-3.4:=
	>=dev-libs/libportal-0.6:0=[gtk]
	>=dev-db/sqlite-3.22:3
	>=net-libs/webkit-gtk-2.43.4:6

	dev-libs/gmp:0=
"
RDEPEND="${DEPEND}
	x11-themes/adwaita-icon-theme
"
# appstream-glib needed for appdata.xml gettext translation
BDEPEND="
	dev-libs/appstream-glib
	dev-util/gdbus-codegen
	dev-util/glib-utils
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PATCHES=(
	# Test not ready to be run in sandboxed systems, also need
	# mesa[zink]. Skip, as done by Debian.
	# https://bugs.gentoo.org/928015
	# https://bugs.gentoo.org/847862
	# https://gitlab.gnome.org/GNOME/epiphany/-/issues/2209
	# https://gitlab.gnome.org/GNOME/epiphany/-/issues/2271
	"${FILESDIR}/${PN}-46.2-disable-web-view-test.patch"
)

src_prepare() {
	default
	xdg_environment_reset
}

src_configure() {
	local emesonargs=(
		-Ddeveloper_mode=false
		-Dtech_preview=false
		$(meson_feature test unit_tests)
		-Dgranite=disabled
	)
	meson_src_configure
}

src_test() {
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
