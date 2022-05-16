# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer-meson

DESCRIPTION="Icecast server sink plugin for GStreamer"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 ~x86"

RDEPEND=">=media-libs/libshout-2.3.1-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
