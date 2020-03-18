# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer

DESCRIPTION="MusicIP audio fingerprinting plugin for GStreamer"
KEYWORDS="~alpha amd64 ~hppa ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=media-libs/libofa-0.9.3-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
