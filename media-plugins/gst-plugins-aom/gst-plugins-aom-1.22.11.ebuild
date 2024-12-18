# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="Alliance for Open Media AV1 plugin for GStreamer"
KEYWORDS="amd64 ~arm64 x86"

RDEPEND="media-libs/libaom:0=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
