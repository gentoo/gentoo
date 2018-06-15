# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer

DESCRIPTION="AMR-WB audio encoder plugin for GStreamer"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-libs/vo-amrwbenc-0.1.2-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
