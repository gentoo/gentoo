# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-voamrwbenc/gst-plugins-voamrwbenc-1.4.5.ebuild,v 1.3 2015/03/15 13:41:10 pacho Exp $

EAPI="5"
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer

DESCRIPTION="GStreamer plugin for encoding AMR-WB"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=media-libs/vo-amrwbenc-0.1.2-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
