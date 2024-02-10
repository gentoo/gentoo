# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="Secure reliable transport (SRT) transfer plugin for GStreamer"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	net-libs/srt:=[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
