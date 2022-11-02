# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer-meson

DESCRIPTION="FLAC encoder/decoder/tagger plugin for GStreamer"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~sparc x86"

RDEPEND=">=media-libs/flac-1.2.1-r5:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
