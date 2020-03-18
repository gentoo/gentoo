# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_6 )

inherit gnome.org gnome2-utils meson python-any-r1 virtualx xdg

DESCRIPTION="Access, organize and share your photos on GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Photos"

LICENSE="GPL-3+ LGPL-2+ CC0-1.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="flickr test upnp-av"
RESTRICT="!test? ( test )"

DEPEND="
	media-libs/babl
	>=x11-libs/cairo-1.14.0
	>=x11-libs/gdk-pixbuf-2.36.8:2
	>=media-libs/gegl-0.4.0:0.4[cairo,raw]
	sci-geosciences/geocode-glib
	>=media-libs/gexiv2-0.10.8
	>=dev-libs/glib-2.57.2:2
	>=net-libs/gnome-online-accounts-3.8.0:=
	>=media-libs/grilo-0.3.5:0.3=
	gnome-base/gsettings-desktop-schemas
	>=x11-libs/gtk+-3.22.16:3
	>=dev-libs/libdazzle-3.26.0
	>=dev-libs/libgdata-0.15.2:0=[gnome-online-accounts]
	>=net-libs/libgfbgraph-0.2.1:0.2
	virtual/jpeg:0
	>=media-libs/libpng-1.6:0=
	>=app-misc/tracker-2.0:0/2.0
	sys-apps/dbus
"
# gnome-online-miners is also used for google, facebook, DLNA - not only flickr
# but out of all the grilo-plugins, only upnp-av and flickr get used, which have USE flags here,
# so don't pull it always, but only if either USE flag is enabled.
# tracker-miners gschema used at runtime.
RDEPEND="${DEPEND}
	net-misc/gnome-online-miners[flickr?]
	upnp-av? ( media-plugins/grilo-plugins:0.3[upnp-av] )
	flickr? ( media-plugins/grilo-plugins:0.3[flickr] )
	>=app-misc/tracker-miners-2
"
BDEPEND="
	dev-libs/appstream-glib
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
	use test && has_version "dev-util/dogtail[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	xdg_src_prepare
	sed -i -e "/photos_docdir.*=.*join_paths/s/meson.project_name()/'${PF}'/" meson.build
}

src_configure() {
	local emesonargs=(
		$(meson_use test dogtail)
		-Dinstalled_tests=false
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
