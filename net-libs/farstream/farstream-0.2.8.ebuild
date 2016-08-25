# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 )

inherit gnome2 python-any-r1

DESCRIPTION="Audio/video conferencing framework specifically designed for instant messengers"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/Farstream"
SRC_URI="https://freedesktop.org/software/farstream/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ~ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="+introspection test upnp"
SLOT="0.2/5" # .so version

# Tests need shmsink from gst-plugins-bad, which isn't packaged
# FIXME: do an out-of-tree build for tests if USE=-msn
RESTRICT="test"

COMMONDEPEND="
	>=media-libs/gstreamer-1.4:1.0
	>=media-libs/gst-plugins-base-1.4:1.0
	>=dev-libs/glib-2.32:2
	>=net-libs/libnice-0.1.8
	introspection? ( >=dev-libs/gobject-introspection-0.10.11:= )
	upnp? ( >=net-libs/gupnp-igd-0.2:= )
"
RDEPEND="${COMMONDEPEND}
	>=media-libs/gst-plugins-good-1.4:1.0
	>=media-libs/gst-plugins-bad-1.4:1.0
	media-plugins/gst-plugins-libnice:1.0
"
DEPEND="${COMMONDEPEND}
	${PYTHON_DEPS}
	>=dev-util/gtk-doc-am-1.18
	virtual/pkgconfig
	test? (
		media-libs/gst-plugins-base:1.0[vorbis]
		media-libs/gst-plugins-good:1.0 )
"

pkg_setup() {
	python-any-r1_pkg_setup
}

src_configure() {
	plugins="fsrawconference,fsrtpconference,fsfunnel,fsrtcpfilter,fsvideoanyrate"
	gnome2_src_configure \
		--disable-static \
		$(use_enable introspection) \
		$(use_enable upnp gupnp) \
		--with-plugins=${plugins}
}

src_compile() {
	# Prevent sandbox violations, bug #539224
	# https://bugzilla.gnome.org/show_bug.cgi?id=744135
	# https://bugzilla.gnome.org/show_bug.cgi?id=744134
	addpredict /dev
	gnome2_src_compile
}
