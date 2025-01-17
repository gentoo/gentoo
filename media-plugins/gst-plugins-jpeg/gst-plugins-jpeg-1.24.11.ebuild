# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer-meson

DESCRIPTION="JPEG image encoder/decoder plugin for GStreamer"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="media-libs/libjpeg-turbo:0=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
