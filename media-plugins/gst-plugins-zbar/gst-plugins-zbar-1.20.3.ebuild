# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="Bar codes detection in video streams for GStreamer"
KEYWORDS="~amd64"

RDEPEND=">=media-gfx/zbar-0.10_p20121015-r2[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
