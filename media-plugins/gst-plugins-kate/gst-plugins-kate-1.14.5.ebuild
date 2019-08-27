# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer

DESCRIPTION="Kate overlay codec suppport plugin for GStreamer"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=media-libs/libkate-0.1.7[${MULTILIB_USEDEP}]
	>=media-libs/libtiger-0.3.2[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
