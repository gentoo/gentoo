# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="AAC audio encoder plugin for GStreamer"
KEYWORDS="~alpha amd64 ~arm ~ia64 ppc ~ppc64 ~sparc x86"

RDEPEND=">=media-libs/faac-1.28-r3[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
