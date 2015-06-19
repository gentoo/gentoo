# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gst-plugins-base/gst-plugins-base-1.4.5.ebuild,v 1.9 2015/06/07 10:49:41 maekke Exp $

EAPI="5"

GST_ORG_MODULE="gst-plugins-base"
inherit gstreamer

DESCRIPTION="Basepack of plugins for gstreamer"
HOMEPAGE="http://gstreamer.freedesktop.org/"

LICENSE="GPL-2+ LGPL-2+"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="alsa +introspection ivorbis +ogg +orc +pango theora +vorbis X"
REQUIRED_USE="
	ivorbis? ( ogg )
	theora? ( ogg )
	vorbis? ( ogg )
"

RDEPEND="
	app-text/iso-codes
	>=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	>=media-libs/gstreamer-${PV}:1.0[introspection?,${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	alsa? ( >=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-1.31.1 )
	ivorbis? ( >=media-libs/tremor-0_pre20130223[${MULTILIB_USEDEP}] )
	ogg? ( >=media-libs/libogg-1.3.0[${MULTILIB_USEDEP}] )
	orc? ( >=dev-lang/orc-0.4.18[${MULTILIB_USEDEP}] )
	pango? ( >=x11-libs/pango-1.36.3[${MULTILIB_USEDEP}] )
	theora? ( >=media-libs/libtheora-1.1.1[encode,${MULTILIB_USEDEP}] )
	vorbis? ( >=media-libs/libvorbis-1.3.3-r1[${MULTILIB_USEDEP}] )
	X? (
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXv-1.0.10[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.12
	X? (
		>=x11-proto/videoproto-2.3.1-r1[${MULTILIB_USEDEP}]
		>=x11-proto/xextproto-7.2.1-r1[${MULTILIB_USEDEP}]
		>=x11-proto/xproto-7.0.24[${MULTILIB_USEDEP}] )
"

src_prepare() {
	# The AC_PATH_XTRA macro unnecessarily pulls in libSM and libICE even
	# though they are not actually used. This needs to be fixed upstream by
	# replacing AC_PATH_XTRA with PKG_CONFIG calls, upstream bug #731047
	sed -i -e 's:X_PRE_LIBS -lSM -lICE:X_PRE_LIBS:' "${S}"/configure || die
}

multilib_src_configure() {
	gstreamer_multilib_src_configure \
		$(use_enable alsa) \
		$(multilib_native_use_enable introspection) \
		$(use_enable ivorbis) \
		$(use_enable ogg) \
		$(use_enable orc) \
		$(use_enable pango) \
		$(use_enable theora) \
		$(use_enable vorbis) \
		$(use_enable X x) \
		$(use_enable X xshm) \
		$(use_enable X xvideo) \
		--disable-debug \
		--disable-examples \
		--disable-freetypetest \
		--disable-static
	# cdparanoia and libvisual are split out, per leio's request

	# bug #366931, flag-o-matic for the whole thing is overkill
	if [[ ${CHOST} == *86-*-darwin* ]] ; then
		sed -i \
			-e '/FLAGS = /s|-O[23]|-O1|g' \
			gst/audioconvert/Makefile \
			gst/volume/Makefile || die
	fi

	if multilib_is_native_abi; then
		local x
		for x in libs plugins; do
			ln -s "${S}"/docs/${x}/html docs/${x}/html || die
		done
	fi
}

multilib_src_install_all() {
	DOCS="AUTHORS NEWS README RELEASE"
	einstalldocs
	prune_libtool_files --modules
}
