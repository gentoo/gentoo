# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer

DESCRIPTION="GStreamer plugin for MPEG/DVD/SVCD/VCD video/audio multiplexing"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
IUSE=""

RDEPEND=">=media-video/mjpegtools-2.1.0-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
