# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-image/vdr-image-0.4.0.ebuild,v 1.1 2015/02/08 11:00:57 hd_brummy Exp $

EAPI=5

inherit vdr-plugin-2

VERSION="1325" #every bump, new version

DESCRIPTION="VDR plugin: display of digital images, like jpeg, tiff, png, bmp"
HOMEPAGE="http://projects.vdr-developer.org/projects/plg-image"
SRC_URI="mirror://vdr-developerorg/${VERSION}/${P}.tgz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="exif"

COMMON_DEPEND=">=media-video/vdr-2
	>=virtual/ffmpeg-9
	>=media-libs/netpbm-10.0
	exif? ( media-libs/libexif )"

DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"

RDEPEND="${COMMON_DEPEND}
	media-tv/gentoo-vdr-scripts"

VDR_RCADDON_FILE="${FILESDIR}/rc-addon-0.3.0.sh"

src_prepare() {
	vdr-plugin-2_src_prepare

	#wrong include
	sed -e 's:<liboutput/stillimage-player.h>:"liboutput/stillimage-player.h":'\
		-i player-image.h

	# dangerous warning
	sed -e "s:mktemp:mkstemp:" -i data-image.c

	epatch "${FILESDIR}/${P}-gentoo.diff"

	# ffmpeg-2.2.12, libav10
	sed -e "s:avcodec_alloc_frame:av_frame_alloc:" \
		-e "s:CODEC_ID_MPEG2VIDEO:AV_CODEC_ID_MPEG2VIDEO:" \
		-i liboutput/encode.c
}

src_install() {
	vdr-plugin-2_src_install

	insinto /etc/vdr/imagecmds
	newins examples/imagecmds.conf imagecmds.example.conf
	newins examples/imagecmds.conf.DE imagecmds.example.conf.de

	insinto /etc/vdr/plugins/image
	doins examples/imagesources.conf

	into /usr/share/vdr/image
	dobin scripts/imageplugin.sh
	newbin scripts/mount.sh mount-image.sh
}
