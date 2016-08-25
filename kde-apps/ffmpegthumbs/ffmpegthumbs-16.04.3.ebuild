# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_BLOCK_SLOT4="false"
inherit kde5

DESCRIPTION="FFmpeg based thumbnail generator for video files"
KEYWORDS="amd64 x86"
IUSE="libav"

RDEPEND="
	$(add_frameworks_dep kio)
	$(add_qt_dep qtgui)
	libav? ( media-video/libav:= )
	!libav? ( media-video/ffmpeg:0= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"
