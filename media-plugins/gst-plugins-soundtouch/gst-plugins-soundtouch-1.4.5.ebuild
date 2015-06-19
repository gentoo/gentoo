# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-soundtouch/gst-plugins-soundtouch-1.4.5.ebuild,v 1.3 2015/03/15 13:40:27 pacho Exp $

EAPI="5"
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer

DESCRIPTION="GStreamer elements for beats-per-minute detection and pitch controlling"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=media-libs/libsoundtouch-1.7.1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
