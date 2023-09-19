# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer-meson

DESCRIPTION="Wavpack audio encoder/decoder plugin for GStreamer"
KEYWORDS="~alpha amd64 ~arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~sparc x86"

RDEPEND=">=media-sound/wavpack-4.60.1-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
