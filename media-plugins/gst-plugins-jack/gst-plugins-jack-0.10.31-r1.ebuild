# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-jack/gst-plugins-jack-0.10.31-r1.ebuild,v 1.11 2014/10/11 13:15:28 maekke Exp $

EAPI="5"

GST_ORG_MODULE=gst-plugins-good
inherit gstreamer

DESCRIPION="GStreamer source/sink to transfer audio data with JACK ports"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~amd64-fbsd"
IUSE=""

RDEPEND=">=media-sound/jack-audio-connection-kit-0.121.3-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
