# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-jpeg/gst-plugins-jpeg-1.4.5.ebuild,v 1.6 2015/03/29 10:56:26 jer Exp $

EAPI="5"

GST_ORG_MODULE=gst-plugins-good
inherit gstreamer

DESCRIPTION="GStreamer encoder/decoder for JPEG format"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ppc ppc64 ~sparc x86"
IUSE=""

RDEPEND=">=virtual/jpeg-0-r2[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
