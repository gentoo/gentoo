# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..11} )

inherit gnome.org gnome2-utils meson python-any-r1 virtualx xdg

DESCRIPTION="Access, organize and share your photos on GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Photos"

LICENSE="GPL-3+ LGPL-2+ CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="test upnp-av"
RESTRICT="!test? ( test )"

DEPEND="
	media-libs/babl
	>=x11-libs/cairo-1.14.0
	>=x11-libs/gdk-pixbuf-2.36.8:2
	>=media-libs/gegl-0.4.0:0.4[cairo,raw]
	sci-geosciences/geocode-glib:2
	>=media-libs/gexiv2-0.14.0
	>=dev-libs/glib-2.62.0:2
	dev-libs/libportal:=[gtk]
	>=net-libs/gnome-online-accounts-3.8.0:=
	gnome-base/gsettings-desktop-schemas
	>=x11-libs/gtk+-3.22.16:3
	>=dev-libs/libdazzle-3.26.0
	>=gui-libs/libhandy-1.1.90:1
	media-libs/libjpeg-turbo:0=
	>=media-libs/libpng-1.6:0=
	app-misc/tracker:3
	sys-apps/dbus
"
# >=dev-libs/libgdata-0.17.13:0=[gnome-online-accounts] # Upstream left this commented in meson.build. Probably comes back with the next version

# gnome-online-miners is also used for google, facebook, DLNA - not only upnp-av
# but out of all the grilo-plugins, only upnp-av gets used, which has a USE flag here,
# so don't pull it always, but only if USE flag is enabled.
# tracker-miners gschema used at runtime.
RDEPEND="${DEPEND}
	net-misc/gnome-online-miners
	upnp-av? ( media-plugins/grilo-plugins:0.3[upnp-av] )
	app-misc/tracker-miners:3
"
BDEPEND="
	dev-libs/appstream-glib
	dev-libs/libxslt
	app-text/docbook-xsl-stylesheets
	dev-util/desktop-file-utils
	dev-util/gdbus-codegen
	dev-util/glib-utils
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	test? ( $(python_gen_any_dep 'dev-util/dogtail[${PYTHON_USEDEP}]') )
"

DOCS=() # meson installs docs itself

python_check_deps() {
	use test && python_has_version "dev-util/dogtail[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	default
	xdg_environment_reset
	sed -i -e "/photos_docdir.*=.*join_paths/s/meson.project_name()/'${PF}'/" meson.build
}

src_configure() {
	local emesonargs=(
		$(meson_use test dogtail)
		-Dflatpak=false
		-Dinstalled_tests=false
		-Dmanuals=true
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
