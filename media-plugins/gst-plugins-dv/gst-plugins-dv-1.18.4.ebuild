# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer-meson

DESCRIPTION="DV demuxer and decoder plugin for GStreamer"
KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND=">=media-libs/libdv-1.0.0-r3[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
