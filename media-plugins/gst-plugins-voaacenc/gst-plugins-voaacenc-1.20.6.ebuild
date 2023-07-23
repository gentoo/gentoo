# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="AAC encoder plugin for GStreamer"
KEYWORDS="amd64 ~x86"

RDEPEND=">=media-libs/vo-aacenc-0.1.3[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
