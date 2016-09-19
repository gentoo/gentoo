# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GST_ORG_MODULE=gst-plugins-ugly

inherit gstreamer

DESCRIPTION="MP3 decoder plugin for GStreamer"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=media-sound/mpg123-1.23[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
