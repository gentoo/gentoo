# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer-meson

DESCRIPTION="Video overlay plugin based on cairo for GStreamer"
KEYWORDS="~amd64 ~arm64"

RDEPEND=">=x11-libs/cairo-1.10[glib,${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
