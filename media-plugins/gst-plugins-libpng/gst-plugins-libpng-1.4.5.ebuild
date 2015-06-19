# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-libpng/gst-plugins-libpng-1.4.5.ebuild,v 1.5 2015/03/15 13:38:10 pacho Exp $

EAPI="5"

GST_ORG_MODULE=gst-plugins-good
inherit gstreamer

DESCRIPTION="GStreamer encoder/decoder for PNG images"
KEYWORDS="~alpha amd64 ~arm ppc ppc64 ~sparc x86"
IUSE=""

RDEPEND=">=media-libs/libpng-1.6.10:0=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
