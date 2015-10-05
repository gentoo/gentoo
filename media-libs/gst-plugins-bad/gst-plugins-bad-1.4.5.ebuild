# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GST_ORG_MODULE="gst-plugins-bad"

inherit eutils flag-o-matic gstreamer

DESCRIPTION="Less plugins for GStreamer"
HOMEPAGE="http://gstreamer.freedesktop.org/"

LICENSE="LGPL-2"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"

IUSE="X egl gles2 +introspection opengl +orc vnc wayland"
REQUIRED_USE="
	egl? ( !gles2 )
	gles2? ( !egl !opengl )
	opengl? ( X )
	wayland? ( egl )
"

# dtmf plugin moved from bad to good in 1.2
# X11 is automagic for now, upstream #709530
RDEPEND="
	>=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-1.4:${SLOT}[${MULTILIB_USEDEP}]
	>=media-libs/gstreamer-1.4:${SLOT}[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-1.31.1 )

	egl? ( >=media-libs/mesa-9.1.6[egl,${MULTILIB_USEDEP}] )
	gles2? ( >=media-libs/mesa-9.1.6[gles2,${MULTILIB_USEDEP}] )
	opengl? (
		>=media-libs/mesa-9.1.6[${MULTILIB_USEDEP}]
		virtual/glu[${MULTILIB_USEDEP}] )
	X? ( x11-libs/libX11[${MULTILIB_USEDEP}] )
	wayland? ( dev-libs/wayland[${MULTILIB_USEDEP}] )

	orc? ( >=dev-lang/orc-0.4.17[${MULTILIB_USEDEP}] )

	!<media-libs/gst-plugins-good-1.1:${SLOT}
	x11-libs/libSM[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.12
"

src_configure() {
	strip-flags
	replace-flags "-O3" "-O2"
	filter-flags "-fprefetch-loop-arrays" # (Bug #22249)

	multilib-minimal_src_configure
}

multilib_src_configure() {
	gstreamer_multilib_src_configure \
		$(multilib_native_use_enable introspection) \
		$(use_enable egl) \
		$(use_enable gles2) \
		$(use_enable opengl) \
		$(use_enable opengl glx) \
		$(use_enable orc) \
		$(use_enable vnc librfb) \
		$(use_enable X x11) \
		$(use_enable wayland) \
		--disable-examples \
		--disable-debug \
		--disable-cocoa \
		--disable-wgl
}

multilib_src_install_all() {
	DOCS="AUTHORS ChangeLog NEWS README RELEASE"
	einstalldocs
	prune_libtool_files --modules
}
