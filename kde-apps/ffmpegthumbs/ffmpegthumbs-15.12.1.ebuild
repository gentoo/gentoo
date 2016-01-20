# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde5

DESCRIPTION="FFmpeg based thumbnail generator for video files"
KEYWORDS=" ~amd64 ~x86"
IUSE="libav"

RDEPEND="
	$(add_frameworks_dep kio)
	dev-qt/qtgui:5
	libav? ( media-video/libav:= )
	!libav? ( media-video/ffmpeg:= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"
