# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer

DESCRIPTION="Bar codes detection in video streams for GStreamer"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=media-gfx/zbar-0.10_p20121015-r2[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
