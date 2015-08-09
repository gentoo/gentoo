# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

VERSION="961" # every bump, new version

inherit vdr-plugin-2 flag-o-matic

DESCRIPTION="VDR plugin: Show another channel in the OSD"
HOMEPAGE="http://projects.vdr-developer.org/projects/plg-osdpip"
SRC_URI="mirror://vdr-developerorg/${VERSION}/${P}.tgz"

KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-1.7.27
	>=media-libs/libmpeg2-0.5.1
	>=virtual/ffmpeg-0.6.90"
RDEPEND="${DEPEND}"

src_prepare() {
	vdr-plugin-2_src_prepare

	# UINT64_C is needed by ffmpeg headers
	append-cxxflags -D__STDC_CONSTANT_MACROS

	epatch "${FILESDIR}/${PN}-0.1.1-ffmpeg-1.patch"
	epatch "${FILESDIR}/${PN}-libav-9.patch"

	# tested with libav10/11, ffmpeg-2.5.4
	sed -e "s:CODEC_ID_MPEG2VIDEO:AV_CODEC_ID_MPEG2VIDEO:"\
		-e "s:avcodec_alloc_frame:av_frame_alloc:"\
		-i decoder.c
}
