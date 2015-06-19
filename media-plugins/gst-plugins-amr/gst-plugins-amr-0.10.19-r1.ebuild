# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-amr/gst-plugins-amr-0.10.19-r1.ebuild,v 1.4 2014/07/23 15:20:35 ago Exp $

EAPI="5"

GST_ORG_MODULE=gst-plugins-ugly
inherit eutils gstreamer

DESCRIPTION="GStreamer plugin for AMRNB/AMRWB codec"
HOMEPAGE="http://gstreamer.freedesktop.org/"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=media-libs/opencore-amr-0.1.3-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

GST_PLUGINS_BUILD="amrnb amrwb"
GST_PLUGINS_BUILD_DIR="amrnb amrwbdec"

src_prepare() {
	# Fix build with current opencore-amr
	epatch "${FILESDIR}"/${P}-headers-location.patch
}
