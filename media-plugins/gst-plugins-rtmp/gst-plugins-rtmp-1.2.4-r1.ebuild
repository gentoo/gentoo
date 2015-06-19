# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-rtmp/gst-plugins-rtmp-1.2.4-r1.ebuild,v 1.4 2014/07/23 15:22:11 ago Exp $

EAPI="5"

GST_ORG_MODULE=gst-plugins-bad
inherit gstreamer

DESCRIPTION="GStreamer plugin for supporting RTMP sources"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=media-video/rtmpdump-2.4_p20131018[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
