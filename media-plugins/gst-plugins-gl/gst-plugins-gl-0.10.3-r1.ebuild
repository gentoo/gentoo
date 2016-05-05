# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GST_TARBALL_SUFFIX="gz"

inherit autotools eutils gstreamer

DESCRIPTION="GStreamer OpenGL plugins"
HOMEPAGE="https://gstreamer.freedesktop.org/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="libvisual"

RDEPEND="
	>=media-libs/glew-1.10.0-r1[${MULTILIB_USEDEP}]
	>=media-libs/libpng-1.6.10:0=[${MULTILIB_USEDEP}]
	>=media-libs/gstreamer-0.10.36-r2:0.10[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-0.10.36:0.10[${MULTILIB_USEDEP}]
	>=virtual/glu-9.0-r1[${MULTILIB_USEDEP}]
	virtual/jpeg:0[${MULTILIB_USEDEP}]
	>=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}]
	>=x11-libs/libSM-1.2.1-r1[${MULTILIB_USEDEP}]
	libvisual? ( >=media-libs/libvisual-0.4.0-r3[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.3
"

# FIXME: some deal with gst-plugin-scanner
RESTRICT=test

src_prepare() {
	# Fix linking, bug 515014 (from 'master')
	epatch "${FILESDIR}/${PN}-0.10.3-jpeg-check.patch"
	eautoreconf
}

# FIXME: add support for libvisual
multilib_src_configure() {
	gstreamer_multilib_src_configure \
		--disable-examples \
		--disable-static \
		--disable-valgrind \
		$(use_enable libvisual)

	if multilib_is_native_abi; then
		local d
		for d in libs plugins; do
			ln -s "${S}"/docs/${d}/html docs/${d}/html || die
		done
	fi
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files --modules
}
