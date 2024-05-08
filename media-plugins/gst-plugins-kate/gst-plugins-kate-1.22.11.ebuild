# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="Kate overlay codec suppport plugin for GStreamer"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND=">=media-libs/libkate-0.1.7[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
