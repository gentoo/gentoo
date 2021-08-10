# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2

DESCRIPTION="A library that implements the DMAP family of protocols"
HOMEPAGE="https://www.flyn.org/projects/libdmapsharing/"
SRC_URI="https://www.flyn.org/projects/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="3.0/2"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="+introspection test"
RESTRICT="!test? ( test )"

# Vala/libgee/gtk+:2 is only used when maintainer-mode is enabled
# Doesn't seem to be used for anything...
RDEPEND="
	>=dev-libs/glib-2.36:2
	x11-libs/gdk-pixbuf:2
	>=net-dns/avahi-0.6[dbus]
	>=net-libs/libsoup-2.48.0:2.4
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	sys-libs/zlib
	introspection? ( >=dev-libs/gobject-introspection-1.30:= )
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	dev-util/gtk-doc-am
	virtual/pkgconfig
	test? ( >=dev-libs/check-0.9.4 )
"

src_prepare() {
	# Remove useless CFLAGS alteration in configure
	sed -e 's/CFLAGS -O2/CFLAGS/' \
		-i configure.ac configure || die
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--with-mdns=avahi \
		$(use_enable introspection) \
		$(use_enable test tests) \
		$(use_enable test check)
}
