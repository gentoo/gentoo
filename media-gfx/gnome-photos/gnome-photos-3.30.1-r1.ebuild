# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit gnome2 python-any-r1 virtualx

DESCRIPTION="Access, organize and share your photos on GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Photos"

LICENSE="GPL-3+ LGPL-2+ CC0-1.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="flickr test upnp-av"

COMMON_DEPEND="
	>=app-misc/tracker-2.0:0/2.0
	>=dev-libs/glib-2.44:2
	>=dev-libs/libdazzle-3.26.0
	gnome-base/gsettings-desktop-schemas
	>=dev-libs/libgdata-0.15.2:0=[gnome-online-accounts]
	media-libs/babl
	>=media-libs/gegl-0.4.0:0.4[cairo,raw]
	>=media-libs/gexiv2-0.10.8
	>=media-libs/grilo-0.3.5:0.3=
	>=media-libs/libpng-1.6:0=
	>=net-libs/gnome-online-accounts-3.8:=
	>=net-libs/libgfbgraph-0.2.1:0.2
	sci-geosciences/geocode-glib
	>=x11-libs/cairo-1.14
	>=x11-libs/gdk-pixbuf-2.32:2
	>=x11-libs/gtk+-3.22.16:3
	virtual/jpeg:0
"
# gnome-online-miners is also used for google, facebook, DLNA - not only flickr
# but out of all the grilo-plugins, only upnp-av and flickr get used, which have USE flags here,
# so don't pull it always, but only if either USE flag is enabled
RDEPEND="${COMMON_DEPEND}
	net-misc/gnome-online-miners[flickr?]
	upnp-av? ( media-plugins/grilo-plugins:0.3[upnp-av] )
	flickr? ( media-plugins/grilo-plugins:0.3[flickr] )
"
DEPEND="${COMMON_DEPEND}
	dev-libs/appstream-glib
	dev-util/desktop-file-utils
	dev-util/glib-utils
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	test? ( $(python_gen_any_dep 'dev-util/dogtail[${PYTHON_USEDEP}]') )
" # app-text/yelp-tools needed for eautoreconf; otherwise just itstool
RDEPEND="${RDEPEND}
	>=app-misc/tracker-miners-2
"

python_check_deps() {
	use test && has_version "dev-util/dogtail[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	gnome2_src_configure \
		$(use_enable test dogtail)
}

src_test() {
	virtx emake check
}
