# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="SBC encoder and decoder plugin for GStreamer"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/sbc[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
