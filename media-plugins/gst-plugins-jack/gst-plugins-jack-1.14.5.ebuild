# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer

DESCRIPION="JACK audio server source/sink plugin for GStreamer"
KEYWORDS="alpha amd64 arm arm64 ~hppa ia64 ppc ppc64 ~sparc x86"
IUSE=""

RDEPEND="virtual/jack[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
