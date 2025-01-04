# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="RTMP source/sink plugin for GStreamer"
KEYWORDS="amd64 ~arm64 ~x86"

RDEPEND=">=media-video/rtmpdump-2.4_p20131018[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
