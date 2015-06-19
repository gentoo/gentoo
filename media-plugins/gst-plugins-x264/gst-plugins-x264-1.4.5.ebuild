# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-x264/gst-plugins-x264-1.4.5.ebuild,v 1.6 2015/03/29 11:11:28 jer Exp $

EAPI="5"
GST_ORG_MODULE=gst-plugins-ugly

inherit gstreamer

KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ppc ppc64 ~sparc x86 ~amd64-fbsd"
IUSE=""

# 20111220 ensures us X264_BUILD >= 120
RDEPEND=">=media-libs/x264-0.0.20130506:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
