# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer-meson

DESCRIPTION="Icecast server sink plugin for GStreamer"
KEYWORDS="~alpha amd64 ~arm64 ~ppc ~ppc64 ~x86"

# Requires >= 2.4.3 but prefers >= 2.4.6
RDEPEND=">=media-libs/libshout-2.4.6[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
