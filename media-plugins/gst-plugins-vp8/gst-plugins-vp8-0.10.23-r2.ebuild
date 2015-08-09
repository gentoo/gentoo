# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

GST_ORG_MODULE=gst-plugins-bad
inherit eutils gstreamer

DESCRIPTION="GStreamer decoder for vpx video format"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~amd64-fbsd"
IUSE=""

RDEPEND=">=media-libs/libvpx-1.2.0_pre20130625[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

src_prepare() {
	# Fix zero-bitrate vp8 encoding with libvpx-1.1, bug #435282
	epatch "${FILESDIR}/${PN}-0.10.23-libvpx-1.1.patch"

	local pdir=$(gstreamer_get_plugin_dir)
	# gstbasevideo has no .pc
	sed -e "s:\$(top_builddir)/gst-libs/gst/video/.*\.la:-lgstbasevideo-${SLOT}:" \
		-i "${pdir}"/Makefile.{am,in} || die
}
