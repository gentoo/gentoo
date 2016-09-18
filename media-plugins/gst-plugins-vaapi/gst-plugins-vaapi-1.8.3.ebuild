# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils multilib-minimal

MY_PN="gstreamer-vaapi"
DESCRIPTION="Hardware accelerated video decoding through VA-API plugin for GStreamer"
HOMEPAGE="https://cgit.freedesktop.org/gstreamer/gstreamer-vaapi"
SRC_URI="https://gstreamer.freedesktop.org/src/${MY_PN}/${MY_PN}-${PV}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="1.0"
KEYWORDS="~amd64 ~x86"

IUSE="+drm egl opengl wayland +X"
REQUIRED_USE="|| ( drm opengl wayland X )"

RDEPEND="
	>=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	>=media-libs/gstreamer-${PV}:${SLOT}[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-bad-${PV}:${SLOT}[opengl?,${MULTILIB_USEDEP}]
	>=x11-libs/libva-1.4.0[drm?,X?,opengl?,wayland?,${MULTILIB_USEDEP}]
	drm? (
		>=virtual/libudev-208:=[${MULTILIB_USEDEP}]
		>=x11-libs/libdrm-2.4.46[${MULTILIB_USEDEP}] )
	egl? (
		>=media-libs/gst-plugins-bad-${PV}:${SLOT}[opengl,${MULTILIB_USEDEP}] )
	opengl? (
		>=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}]
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXrandr-1.4.2[${MULTILIB_USEDEP}] )
	wayland? ( >=dev-libs/wayland-1.0.6[${MULTILIB_USEDEP}] )
	X? (
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXrandr-1.4.2[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.12
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
"

S="${WORKDIR}/${MY_PN}-${PV}"

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf \
		--disable-static \
		$(use_enable drm) \
		$(use_enable egl) \
		$(use_enable opengl glx) \
		$(use_enable wayland) \
		$(use_enable X x11)
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files --modules
}
