# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer

DESCRIPTION="Secure reliable transport (SRT) transfer plugin for GStreamer"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	net-libs/srt:=[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
