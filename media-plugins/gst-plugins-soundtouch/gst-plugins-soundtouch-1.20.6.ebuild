# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="Beats-per-minute detection and pitch controlling plugin for GStreamer"
KEYWORDS="amd64 ~x86"

RDEPEND=">=media-libs/libsoundtouch-1.7.1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
