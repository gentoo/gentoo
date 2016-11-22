# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit gnome2 python-any-r1 virtualx

DESCRIPTION="Access, organize and share your photos on GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Photos"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=app-misc/tracker-1:=[miner-fs]
	>=dev-libs/glib-2.39.3:2
	gnome-base/gnome-desktop:3=
	>=dev-libs/libgdata-0.15.2:0=[gnome-online-accounts]
	media-libs/babl
	>=media-libs/gegl-0.3.5:0.3[cairo,jpeg2k,raw]
	media-libs/gexiv2
	>=media-libs/grilo-0.3.0:0.3=
	>=media-libs/libpng-1.6:0=
	media-plugins/grilo-plugins:0.3[upnp-av]
	>=net-libs/gnome-online-accounts-3.8:=
	>=net-libs/libgfbgraph-0.2.1:0.2
	>=x11-libs/cairo-1.14
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.19.1:3
"
DEPEND="${RDEPEND}
	dev-util/desktop-file-utils
	>=dev-util/intltool-0.50.1
	dev-util/itstool
	virtual/pkgconfig
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-util/dogtail[${PYTHON_USEDEP}]') )
"
# eautoreconf
#	app-text/yelp-tools

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
