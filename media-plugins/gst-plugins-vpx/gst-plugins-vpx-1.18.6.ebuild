# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer-meson

DESCRIPTION="VP8/VP9 video encoder/decoder plugin for GStreamer"
KEYWORDS="amd64 arm arm64 ~ia64 ~mips ppc ppc64 ~riscv ~sparc x86"
IUSE=""

RDEPEND=">=media-libs/libvpx-1.3.0:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
