# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer-meson

DESCRIPTION="Adaptive demuxer plugins for Gstreamer"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-libs/libxml2-2.8[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
