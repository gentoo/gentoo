# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer

DESCRIPTION="Wavpack audio encoder/decoder plugin for GStreamer"
KEYWORDS="alpha amd64 ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~sparc x86"
IUSE=""

RDEPEND=">=media-sound/wavpack-4.60.1-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
