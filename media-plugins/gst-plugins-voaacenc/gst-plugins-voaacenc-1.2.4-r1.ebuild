# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-voaacenc/gst-plugins-voaacenc-1.2.4-r1.ebuild,v 1.4 2014/07/23 15:22:35 ago Exp $

EAPI="5"

GST_ORG_MODULE=gst-plugins-bad
inherit gstreamer

DESCRIPTION="GStreamer plugin for encoding AAC"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=media-libs/vo-aacenc-0.1.3[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
