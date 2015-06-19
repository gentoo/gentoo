# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/farstream/farstream-0.1.2-r1.ebuild,v 1.19 2015/05/01 12:51:19 eva Exp $

EAPI="4"
PYTHON_DEPEND="2"

inherit eutils python

DESCRIPTION="Audio/video conferencing framework specifically designed for instant messengers"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/Farstream"
SRC_URI="http://freedesktop.org/software/farstream/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
KEYWORDS="alpha ia64 sparc"
IUSE="+introspection python msn test upnp"

SLOT="0.1"

# Tests need shmsink from gst-plugins-bad, which isn't packaged
RESTRICT="test"

COMMONDEPEND="
	>=media-libs/gstreamer-0.10.33:0.10
	>=media-libs/gst-plugins-base-0.10.33:0.10
	>=dev-libs/glib-2.30:2
	>=net-libs/libnice-0.1.0
	introspection? ( >=dev-libs/gobject-introspection-0.10.11 )
	python? (
		>=dev-python/pygobject-2.16:2
		>=dev-python/gst-python-0.10.10:0.10 )
	upnp? ( net-libs/gupnp-igd )
"
RDEPEND="${COMMONDEPEND}
	>=media-libs/gst-plugins-good-0.10.17:0.10
	>=media-libs/gst-plugins-bad-0.10.17:0.10
	|| (
		>=media-plugins/gst-plugins-libnice-0.1.0:0.10
		<=net-libs/libnice-0.1.3[gstreamer] )
	msn? ( >=media-plugins/gst-plugins-mimic-0.10.17:0.10 )
	!net-libs/farsight2
"
# This package is just a rename from farsight2

MAKEOPTS="${MAKEOPTS} -j1" # Parallel is completely broken on this slot, bug #434618

DEPEND="${COMMONDEPEND}
	dev-util/gtk-doc-am
	virtual/pkgconfig
	test? (
		media-libs/gst-plugins-good:0.10
		media-plugins/gst-plugins-vorbis:0.10 )"

pkg_setup() {
	if use python; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_prepare() {
	# Fix building with gobject-introspection-1.33.x, bug #425096
	epatch "${FILESDIR}/${P}-introspection-tag-order.patch"
}

src_configure() {
	plugins="fsrawconference,fsrtpconference,fsfunnel,fsrtcpfilter,fsvideoanyrate"
	use msn && plugins="${plugins},fsmsnconference"
	econf --disable-static \
		$(use_enable introspection) \
		$(use_enable python) \
		$(use_enable upnp gupnp) \
		--with-plugins=${plugins}
}

src_install() {
	# Parallel install fails, bug #434618 (fixed in latest slot)
	emake -j1 install DESTDIR="${D}"
	dodoc AUTHORS README ChangeLog

	# Remove .la files since static libs are no longer being installed
	find "${D}" -name '*.la' -exec rm -f '{}' + || die
}

src_test() {
	# FIXME: do an out-of-tree build for tests if USE=-msn
	if ! use msn; then
		elog "Tests disabled without msn use flag"
		return
	fi

	emake -j1 check
}
