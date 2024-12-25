# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer-meson

DESCRIPTION="MPEG2 encoder plugin for GStreamer"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND=">=media-sound/twolame-0.3.13-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
