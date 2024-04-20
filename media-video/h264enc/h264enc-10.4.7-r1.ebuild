# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit optfeature

DESCRIPTION="Script to encode H.264/AVC/MPEG-4 Part 10 formats"
HOMEPAGE="https://h264enc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="media-video/mplayer[encode,x264]
	sys-apps/coreutils
	sys-apps/pv
	app-alternatives/bc
	sys-process/time"

PATCHES=( "${FILESDIR}/${P}-libaacplusenc.patch" )

src_install() {
	dobin ${PN}
	doman man/${PN}.1
	dodoc doc/*
	docinto matrices
	dodoc matrices/*
}

pkg_postinst() {
	optfeature "aac support" "media-libs/faac media-libs/libaacplus"
	optfeature "dvd support" media-video/lsdvd
	optfeature "flac support" media-libs/flac
	optfeature "lame (mp3) support" media-sound/lame
	optfeature "matroska (mkv) support" media-video/mkvtoolnix
	optfeature "mp4 support" media-video/gpac[a52]
	optfeature "ogm support" media-sound/ogmtools
	optfeature "vorbis support" media-sound/vorbis-tools
}
