# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libdmapsharing/libdmapsharing-2.9.30.ebuild,v 1.3 2015/03/15 13:30:41 pacho Exp $

EAPI=5
inherit eutils

DESCRIPTION="A library that implements the DMAP family of protocols"
HOMEPAGE="http://www.flyn.org/projects/libdmapsharing"
SRC_URI="http://www.flyn.org/projects/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="3.0/2"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="+introspection test"

# Vala/libgee/gtk+:2 is only used when maintainer-mode is enabled
# Doesn't seem to be used for anything...
# TODO: implement tests (requires dev-libs/check)
RDEPEND="
	>=dev-libs/glib-2.36:2
	x11-libs/gdk-pixbuf:2

	>=net-dns/avahi-0.6
	>=net-libs/libsoup-2.32:2.4
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0

	sys-libs/zlib

	introspection? ( >=dev-libs/gobject-introspection-1.30 )
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	virtual/pkgconfig
	test? ( dev-libs/check )
"

src_prepare() {
	# Remove useless CFLAGS alteration in configure
	sed -e 's/CFLAGS -O2/CFLAGS/' \
		-i configure.ac configure || die
}

src_configure() {
	econf \
		--disable-gtk-doc \
		--disable-maintainer-mode \
		--with-mdns=avahi \
		$(use_enable introspection) \
		$(use_enable test tests)
}

src_install() {
	default
	prune_libtool_files
}
