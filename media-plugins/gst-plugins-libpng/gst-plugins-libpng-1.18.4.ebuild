# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer-meson

DESCRIPTION="PNG image encoder/decoder plugin for GStreamer"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND=">=media-libs/libpng-1.6.10:0=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

GST_PLUGINS_ENABLED="png"
