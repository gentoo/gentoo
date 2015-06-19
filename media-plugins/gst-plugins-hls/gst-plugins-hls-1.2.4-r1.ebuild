# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-hls/gst-plugins-hls-1.2.4-r1.ebuild,v 1.4 2014/07/23 15:21:15 ago Exp $

EAPI="5"

GST_ORG_MODULE=gst-plugins-bad
inherit gstreamer

DESCRIPTION="HTTP live streaming plugin"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=net-libs/gnutls-2.12.23-r6[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

# FIXME: gsturidownloader does not have a .pc
#src_prepare() {
#	gst-plugins10_system_link \
#		gst-libs/gst/uridownloader:gsturidownloader
#}

multilib_src_compile() {
	emake -C gst-libs/gst/uridownloader

	gstreamer_multilib_src_compile
}
