# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="WebP image format support for GStreamer"
KEYWORDS="~amd64"

RDEPEND=">=media-libs/libwebp-0.2.1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
