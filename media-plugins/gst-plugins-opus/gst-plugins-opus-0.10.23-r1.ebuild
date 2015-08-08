# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

GST_ORG_MODULE=gst-plugins-bad
inherit gstreamer

DESCRIPTION="GStreamer plugin for Opus audio codec support"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~amd64-fbsd"
IUSE=""

COMMON_DEPEND=">=media-libs/opus-1.0.2-r2:=[${MULTILIB_USEDEP}]"
RDEPEND="${COMMON_DEPEND}
	media-plugins/gst-plugins-ogg:${SLOT}[${MULTILIB_USEDEP}]"
DEPEND="${COMMON_DEPEND}"
