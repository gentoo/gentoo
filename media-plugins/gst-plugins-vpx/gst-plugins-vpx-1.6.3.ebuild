# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer

DESCRIPTION="GStreamer decoder for vpx video format"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
IUSE=""

# VP9 is under experimental, do not enable it now
RDEPEND=">=media-libs/libvpx-1.3.0:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
