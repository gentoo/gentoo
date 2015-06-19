# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-modplug/gst-plugins-modplug-0.10.23-r1.ebuild,v 1.9 2015/03/29 11:05:02 jer Exp $

EAPI="5"

GST_ORG_MODULE=gst-plugins-bad
inherit gstreamer

KEYWORDS="~alpha amd64 hppa ppc ppc64 x86"
IUSE=""

RDEPEND=">=media-libs/libmodplug-0.8.8.4-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

src_prepare() {
	# modplug: Specify directory when including stdafx.h, bug #532558
	epatch "${FILESDIR}"/${PN}-0.10.23-include-header.patch
}
