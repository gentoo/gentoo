# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-shout2/gst-plugins-shout2-1.4.5.ebuild,v 1.5 2015/03/15 13:40:09 pacho Exp $

EAPI="5"

GST_ORG_MODULE=gst-plugins-good
inherit gstreamer

DESCRIPTION="GStreamer plugin to send data to an icecast server"
KEYWORDS="~alpha amd64 ppc ppc64 x86"
IUSE=""

RDEPEND=">=media-libs/libshout-2.3.1-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
