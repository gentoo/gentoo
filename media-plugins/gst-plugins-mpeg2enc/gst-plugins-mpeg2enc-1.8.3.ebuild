# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer

DESCRIPTION="MPEG-1/2 video encoding plugin for GStreamer"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=media-video/mjpegtools-2.1.0-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
