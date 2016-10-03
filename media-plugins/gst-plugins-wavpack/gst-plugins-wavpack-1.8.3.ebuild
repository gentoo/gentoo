# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer

DESCRIPTION="Wavpack audio encoder/decoder plugin for GStreamer"
KEYWORDS="alpha amd64 hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~amd64-fbsd"
IUSE=""

RDEPEND=">=media-sound/wavpack-4.60.1-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
