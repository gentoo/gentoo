# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-dvb/gst-plugins-dvb-0.10.23-r1.ebuild,v 1.7 2014/10/11 12:53:07 maekke Exp $

EAPI="5"

GST_ORG_MODULE=gst-plugins-bad
inherit gstreamer

DESCRIPION="GStreamer plugin to allow capture from dvb devices"
KEYWORDS="alpha amd64 arm ppc ppc64 x86"
IUSE=""

RDEPEND=""
DEPEND="virtual/os-headers"
