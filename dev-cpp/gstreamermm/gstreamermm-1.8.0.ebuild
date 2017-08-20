# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_EAUTORECONF="yes"

inherit gnome2 virtualx

DESCRIPTION="C++ interface for GStreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/bindings/cplusplus.html"

LICENSE="LGPL-2.1"
SLOT="1.0/1"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc examples opengl test"

RDEPEND="
	>=media-libs/gstreamer-${PV}:1.0
	>=media-libs/gst-plugins-base-${PV}:1.0
	>=media-libs/gst-plugins-bad-${PV}:1.0[opengl?]
	>=dev-cpp/glibmm-2.47.6:2
	>=dev-cpp/libxmlpp-2.14:2.6
	>=dev-libs/libsigc++-2:2
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		dev-libs/libxslt
		media-gfx/graphviz )
	test? (
		dev-cpp/gtest
		>=media-libs/gst-plugins-base-${PV}:1.0[X,ogg,theora,vorbis]
		>=media-libs/gst-plugins-good-${PV}:1.0
		>=media-plugins/gst-plugins-jpeg-${PV}:1.0 )
"
#   dev-cpp/mm-common"
# eautoreconf needs mm-common

# Installs reference docs into /usr/share/doc/gstreamermm-1.0/
# but that's okay, because the rest of dev-cpp/*mm stuff does the same

PATCHES=(
	# Upstream patches
	"${FILESDIR}"/1.8.0-add-missing-header.patch
	"${FILESDIR}"/1.8.0-gst-bad-pkgconfig-cflags.patch
	"${FILESDIR}"/1.8.0-fix-wrapping.patch
)

src_prepare() {
	if ! use examples; then
		# don't waste time building examples
		sed -e 's/^\(SUBDIRS =.*\)examples\(.*\)$/\1\2/' \
			-i Makefile.am Makefile.in || die
	fi

	sed -e 's/ -Werror/ /' -i tests/Makefile.am tests/Makefile.in || die

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_enable doc documentation) \
		$(use_enable opengl gl) \
		$(use_enable test unittests)
}

src_test() {
	# running tests in parallel fails
	virtx emake -j1 check
}
