# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer

DESCRIPTION="GStreamer encoder/decoder for JPEG format"
KEYWORDS="alpha amd64 arm hppa ~ia64 ~ppc ppc64 ~sparc x86"
IUSE=""

RDEPEND=">=virtual/jpeg-0-r2:0[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
