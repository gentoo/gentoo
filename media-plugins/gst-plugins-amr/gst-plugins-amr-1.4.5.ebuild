# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-amr/gst-plugins-amr-1.4.5.ebuild,v 1.3 2015/03/15 13:36:07 pacho Exp $

EAPI="5"
GST_ORG_MODULE=gst-plugins-ugly

inherit gstreamer

DESCRIPTION="GStreamer plugin for AMRNB/AMRWB codec"
HOMEPAGE="http://gstreamer.freedesktop.org/"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=media-libs/opencore-amr-0.1.3-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

GST_PLUGINS_BUILD="amrnb amrwb"
GST_PLUGINS_BUILD_DIR="amrnb amrwbdec"
