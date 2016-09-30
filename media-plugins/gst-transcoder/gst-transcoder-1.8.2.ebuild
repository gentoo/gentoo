# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{3_4,3_5} )

inherit python-any-r1 xdg

DESCRIPTION="GStreamer Transcoding API"
HOMEPAGE="https://github.com/pitivi/gst-transcoder"
SRC_URI="https://github.com/pitivi/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-libs/gobject-introspection:=
	dev-libs/glib:2
	>=media-libs/gstreamer-${PV}:1.0[introspection]
	>=media-libs/gst-plugins-base-${PV}:1.0[introspection]
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	>=dev-util/meson-0.28.0
	virtual/pkgconfig
"

src_configure() {
	# Not a normal configure
	# --buildtype=plain needed for honoring CFLAGS/CXXFLAGS and not
	# defaulting to debug
	./configure --prefix=/usr --buildtype=plain || die
}

src_compile() {
	addpredict /dev #590848
	# We cannot use 'make' as it won't allow us to build verbosely
	cd build && ninja -v
}
