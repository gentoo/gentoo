# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-shout2/gst-plugins-shout2-0.10.31.ebuild,v 1.9 2015/01/03 10:04:32 leio Exp $

EAPI="5"

inherit gst-plugins-good

DESCRIPTION="GStreamer plugin to send data to an icecast server"
KEYWORDS="sh"
IUSE=""

RDEPEND=">=media-libs/libshout-2"
DEPEND="${RDEPEND}"
