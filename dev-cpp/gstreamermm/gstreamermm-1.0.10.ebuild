# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/gstreamermm/gstreamermm-1.0.10.ebuild,v 1.5 2015/03/15 13:16:29 pacho Exp $

EAPI="5"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="C++ interface for GStreamer"
HOMEPAGE="http://gstreamer.freedesktop.org/bindings/cplusplus.html"

LICENSE="LGPL-2.1"
SLOT="1.0"
KEYWORDS="amd64 ~ppc x86"
IUSE="doc examples test"

RDEPEND="
	>=media-libs/gstreamer-1.0.10:1.0
	>=media-libs/gst-plugins-base-1.0.10:1.0
	>=dev-cpp/glibmm-2.36:2
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
		media-libs/gst-plugins-base:1.0[X,ogg,theora,vorbis]
		media-libs/gst-plugins-good:1.0
		media-plugins/gst-plugins-jpeg:1.0 )
"
#   dev-cpp/mm-common"
# eautoreconf needs mm-common

# Installs reference docs into /usr/share/doc/gstreamermm-1.0/
# but that's okay, because the rest of dev-cpp/*mm stuff does the same

src_prepare() {
	if ! use examples; then
		# don't waste time building examples
		sed -e 's/^\(SUBDIRS =.*\)examples\(.*\)$/\1\2/' \
			-i Makefile.am Makefile.in || die
	fi

	# FIXME: disable endless unittests, report upstream
	sed -e '/test-regression-rewritefile$(EXEEXT) \\/d' \
		-e '/test-regression-seekonstartup$(EXEEXT) \\/d' \
		-i tests/Makefile.in || die

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure $(use_enable doc documentation)
}

src_test() {
	# running tests in parallel fails
	emake -j1 check || die
}
