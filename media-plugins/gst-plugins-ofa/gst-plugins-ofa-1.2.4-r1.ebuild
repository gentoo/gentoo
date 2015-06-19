# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-ofa/gst-plugins-ofa-1.2.4-r1.ebuild,v 1.4 2014/07/23 15:21:55 ago Exp $

EAPI="5"

GST_ORG_MODULE=gst-plugins-bad
inherit gstreamer

KEYWORDS="~alpha amd64 ~hppa ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=media-libs/libofa-0.9.3-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
