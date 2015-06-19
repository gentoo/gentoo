# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-mpeg2enc/gst-plugins-mpeg2enc-1.2.4-r1.ebuild,v 1.4 2014/07/23 15:21:47 ago Exp $

EAPI="5"

GST_ORG_MODULE=gst-plugins-bad
inherit gstreamer

DESCRIPTION="GStreamer plugin for MPEG-1/2 video encoding"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=media-video/mjpegtools-2.1.0-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
