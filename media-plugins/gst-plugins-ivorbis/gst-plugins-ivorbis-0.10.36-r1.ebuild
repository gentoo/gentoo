# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-ivorbis/gst-plugins-ivorbis-0.10.36-r1.ebuild,v 1.7 2014/08/21 10:43:16 ago Exp $

EAPI="5"

GST_ORG_MODULE=gst-plugins-base
inherit gstreamer

KEYWORDS="amd64 ~arm hppa ppc ppc64 x86 ~amd64-fbsd ~x64-macos"
IUSE=""

RDEPEND=">=media-libs/tremor-0_pre20130223[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

GST_PLUGINS_BUILD_DIR="vorbis"

src_prepare() {
	epatch "${FILESDIR}"/0.10.36-header-shuffle.patch

	gstreamer_system_link \
		gst-libs/gst/audio:gstreamer-audio \
		gst-libs/gst/tag:gstreamer-tag
}
