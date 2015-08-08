# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="Script to encode H.264/AVC/MPEG-4 Part 10 formats"
HOMEPAGE="http://h264enc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="aac dvd flac lame matroska mp4 ogm vorbis"

RDEPEND="
	media-video/mplayer[encode,x264]
	sys-apps/coreutils
	sys-apps/pv
	sys-devel/bc
	sys-process/time
	aac? (
		media-libs/faac
		media-sound/aacplusenc )
	dvd? ( media-video/lsdvd )
	flac? ( media-libs/flac )
	lame? ( media-sound/lame )
	matroska? ( media-video/mkvtoolnix )
	mp4? ( >=media-video/gpac-0.4.5[a52] )
	ogm? ( media-sound/ogmtools )
	vorbis? ( media-sound/vorbis-tools )"
DEPEND=""

src_install() {
	dobin ${PN}
	doman man/${PN}.1
	dodoc doc/*
	docinto matrices
	dodoc matrices/*
}
