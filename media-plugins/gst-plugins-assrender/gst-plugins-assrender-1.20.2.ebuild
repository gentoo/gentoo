# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="ASS/SSA rendering with effects support plugin for GStreamer"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc x86"

RDEPEND=">=media-libs/libass-0.10.2:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
