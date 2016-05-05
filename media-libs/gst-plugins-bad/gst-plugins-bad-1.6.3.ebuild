# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GST_ORG_MODULE="gst-plugins-bad"

inherit eutils flag-o-matic gstreamer virtualx

DESCRIPTION="Less plugins for GStreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"

LICENSE="LGPL-2"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~ppc ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"

IUSE="X egl gles2 gtk +introspection opengl +orc vcd vnc wayland"
REQUIRED_USE="
	egl? ( !gles2 )
	gles2? ( !opengl )
	opengl? ( X )
	wayland? ( egl )
"

# dtmf plugin moved from bad to good in 1.2
# X11 is automagic for now, upstream #709530
RDEPEND="
	>=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	>=media-libs/gstreamer-${PV}:${SLOT}[${MULTILIB_USEDEP},introspection?]
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP},introspection?]
	introspection? ( >=dev-libs/gobject-introspection-1.31.1 )

	egl? ( >=media-libs/mesa-9.1.6[egl,${MULTILIB_USEDEP}] )
	gles2? ( >=media-libs/mesa-9.1.6[gles2,${MULTILIB_USEDEP}] )
	opengl? (
		>=media-libs/mesa-9.1.6[${MULTILIB_USEDEP}]
		virtual/glu[${MULTILIB_USEDEP}] )
	X? ( x11-libs/libX11[${MULTILIB_USEDEP}] )
	wayland? ( dev-libs/wayland[${MULTILIB_USEDEP}] )

	gtk? ( >=x11-libs/gtk+-3.15:3[X?,wayland?,${MULTILIB_USEDEP}] )
	orc? ( >=dev-lang/orc-0.4.17[${MULTILIB_USEDEP}] )

	!<media-libs/gst-plugins-good-1.1:${SLOT}
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.12
"

src_prepare() {
	# FIXME: tests are slower than upstream expects
	sed -e 's:/\* tcase_set_timeout.*:tcase_set_timeout (tc_chain, 5 * 60);:' \
		-i tests/check/elements/audiomixer.c || die
}

multilib_src_configure() {
	local myconf=()
	if use opengl || use gles2 ; then
		# Actually enable the gl element, not just libs
		myconf+=( --enable-gl )
	fi

	# Always enable gsettings (no extra dependency)
	# and shm (need a switch for winnt ?)
	gstreamer_multilib_src_configure \
		$(multilib_native_use_enable introspection) \
		$(use_enable egl) \
		$(use_enable gles2) \
		$(use_enable gtk gtk3) \
		$(use_enable opengl) \
		$(use_enable opengl glx) \
		$(use_enable orc) \
		$(use_enable vcd) \
		$(use_enable vnc librfb) \
		$(use_enable wayland) \
		$(use_enable X x11) \
		--disable-examples \
		--disable-debug \
		--disable-cocoa \
		--disable-wgl \
		--enable-shm \
		${myconf[$@]}
		# not ported
		# --enable-gsettings

	if multilib_is_native_abi; then
		local x
		for x in libs plugins; do
			ln -s "${S}"/docs/${x}/html docs/${x}/html || die
		done
	fi
}

multilib_src_test() {
	unset DISPLAY
	# FIXME: tests are slower than upstream expects
	Xemake check -j1
}

multilib_src_install_all() {
	DOCS="AUTHORS ChangeLog NEWS README RELEASE"
	einstalldocs
	prune_libtool_files --modules
}
