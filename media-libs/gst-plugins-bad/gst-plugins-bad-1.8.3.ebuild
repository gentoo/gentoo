# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GST_ORG_MODULE="gst-plugins-bad"

inherit eutils flag-o-matic gstreamer virtualx

DESCRIPTION="Less plugins for GStreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"

LICENSE="LGPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"

IUSE="X bzip2 egl gles2 gtk +introspection opengl +orc vcd vnc wayland"
REQUIRED_USE="
	egl? ( !gles2 )
	gles2? ( !opengl )
	opengl? ( X )
	wayland? ( egl )
"

# dtmf plugin moved from bad to good in 1.2
# X11 is automagic for now, upstream #709530
RDEPEND="
	>=dev-libs/glib-2.40.0:2[${MULTILIB_USEDEP}]
	>=media-libs/gstreamer-${PV}:${SLOT}[${MULTILIB_USEDEP},introspection?]
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP},introspection?]
	introspection? ( >=dev-libs/gobject-introspection-1.31.1:= )

	bzip2? ( >=app-arch/bzip2-1.0.6-r4[${MULTILIB_USEDEP}] )
	egl? ( >=media-libs/mesa-9.1.6[egl,${MULTILIB_USEDEP}] )
	gles2? ( >=media-libs/mesa-9.1.6[gles2,${MULTILIB_USEDEP}] )
	opengl? (
		>=media-libs/mesa-9.1.6[${MULTILIB_USEDEP}]
		virtual/glu[${MULTILIB_USEDEP}] )
	X? ( x11-libs/libX11[${MULTILIB_USEDEP}] )
	wayland? ( >=dev-libs/wayland-1.4.0[${MULTILIB_USEDEP}] )

	gtk? ( >=x11-libs/gtk+-3.15:3[X?,wayland?,${MULTILIB_USEDEP}] )
	orc? ( >=dev-lang/orc-0.4.17[${MULTILIB_USEDEP}] )

	!<media-libs/gst-plugins-good-1.1:${SLOT}
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.12
"

src_prepare() {
	default
	addpredict /dev # Prevent sandbox violations bug #570624
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
		$(use_enable bzip2 bz2) \
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
		--without-player-tests \
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
	# Tests are slower than upstream expects
	virtx emake check CK_DEFAULT_TIMEOUT=300
}

multilib_src_install_all() {
	DOCS="AUTHORS ChangeLog NEWS README RELEASE"
	einstalldocs
	prune_libtool_files --modules
}
