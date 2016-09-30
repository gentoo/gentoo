# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer

DESCRIPION="JACK audio server source/sink plugin for GStreamer"
KEYWORDS="alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~amd64-fbsd"
IUSE=""

RDEPEND=">=media-sound/jack-audio-connection-kit-0.121.3-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
