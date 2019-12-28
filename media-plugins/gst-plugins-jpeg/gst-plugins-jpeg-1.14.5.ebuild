# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer

DESCRIPTION="JPEG image encoder/decoder plugin for GStreamer"
KEYWORDS="alpha amd64 ~arm arm64 ~hppa ia64 ppc ppc64 ~sparc x86"
IUSE=""

RDEPEND=">=virtual/jpeg-0-r2:0[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
