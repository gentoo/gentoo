# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

GST_ORG_MODULE=gst-plugins-good
inherit eutils gstreamer

DESCRIPION="plugin to allow capture from video4linux2 devices"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86"
IUSE="udev"

RDEPEND="
	>=media-libs/libv4l-0.9.5[${MULTILIB_USEDEP}]
	>=media-plugins/gst-plugins-xvideo-${PV}:${SLOT}[${MULTILIB_USEDEP}]
	udev? ( >=virtual/libgudev-208:=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	virtual/os-headers"

GST_PLUGINS_BUILD="gst_v4l2"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.10.31-linux-headers-3.6.patch #437012
	epatch "${FILESDIR}"/${PN}-0.10.31-linux-headers-3.9.patch #468618
}

multilib_src_configure() {
	gstreamer_multilib_src_configure \
		--with-libv4l2 \
		$(use_with udev gudev)
}
