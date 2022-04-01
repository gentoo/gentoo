# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer-meson

DESCRIPTION="MP3 decoder plugin for GStreamer"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ppc64 ~riscv ~sparc ~x86"
IUSE=""

RDEPEND="
	>=media-sound/mpg123-1.23[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
