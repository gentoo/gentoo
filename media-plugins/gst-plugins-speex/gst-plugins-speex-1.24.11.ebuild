# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer-meson

DESCRIPTION="Speex encoder/decoder plugin for GStreamer"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"

RDEPEND=">=media-libs/speex-1.2_rc1-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
