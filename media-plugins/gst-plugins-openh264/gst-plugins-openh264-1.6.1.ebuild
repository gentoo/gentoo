# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer

DESCRIPTION="H.264 encoder/decoder plugin for GStreamer."
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=media-libs/openh264-1.3[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
