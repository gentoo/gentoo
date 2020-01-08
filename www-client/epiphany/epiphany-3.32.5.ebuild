# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org gnome2-utils meson xdg virtualx

DESCRIPTION="GNOME webbrowser based on Webkit"
HOMEPAGE="https://wiki.gnome.org/Apps/Web"

LICENSE="GPL-3+"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"
KEYWORDS="amd64 ~arm64 ~ppc ~ppc64 x86"

DEPEND="
	>=dev-libs/glib-2.56.0:2
	>=x11-libs/gtk+-3.24.0:3
	>=dev-libs/nettle-3.4:=
	>=net-libs/webkit-gtk-2.24.1:4=
	>=x11-libs/cairo-1.2
	>=app-crypt/gcr-3.5.5:=[gtk]
	>=x11-libs/gdk-pixbuf-2.36.5:2
	gnome-base/gsettings-desktop-schemas
	dev-libs/icu:=
	>=app-text/iso-codes-0.35
	>=dev-libs/json-glib-1.2.4
	>=dev-libs/libdazzle-3.31.90
	>=gui-libs/libhandy-0.0.9:0.0=
	>=x11-libs/libnotify-0.5.1
	>=app-crypt/libsecret-0.14
	>=net-libs/libsoup-2.48.0:2.4
	>=dev-libs/libxml2-2.6.12:2
	dev-db/sqlite:3
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
	# Allow /var/tmp prefixed recursive delete (due to package manager setting TMPDIR)
	"${FILESDIR}"/var-tmp-tests.patch
)

src_configure() {
	local emesonargs=(
		-Ddeveloper_mode=false
		# maybe enable later if network-sandbox is off, but in 3.32.4 the network test
		# is commented out upstream anyway
		-Dnetwork_tests=disabled
		-Dtech_preview=false
		$(meson_feature test unit_tests)
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update

	if ! has_version net-libs/webkit-gtk[jpeg2k]; then
		ewarn "Your net-libs/webkit-gtk is built without USE=jpeg2k."
		ewarn "Various image galleries/managers may be broken."
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
