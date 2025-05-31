# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="Bar codes detection in video streams for GStreamer"
KEYWORDS="~amd64 ~arm64"

RDEPEND=">=media-gfx/zbar-0.23.93[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
