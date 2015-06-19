# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/ffmpegsource/ffmpegsource-9999.ebuild,v 1.9 2015/02/27 22:24:32 mgorny Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=1

inherit autotools-utils git-r3

DESCRIPTION="A libav/ffmpeg based source library for easy frame accurate access"
HOMEPAGE="https://github.com/FFMS/ffms2"
EGIT_REPO_URI="https://github.com/FFMS/ffms2.git"

LICENSE="MIT"
SLOT="0/3"
KEYWORDS=""
IUSE="libav static-libs"

RDEPEND="
	sys-libs/zlib
	libav? ( >=media-video/libav-9.17:0= )
	!libav? ( >=media-video/ffmpeg-1.2.6-r1:0= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"
