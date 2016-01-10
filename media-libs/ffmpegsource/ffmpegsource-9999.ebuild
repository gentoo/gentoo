# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1

inherit autotools-utils flag-o-matic git-r3

DESCRIPTION="A libav/ffmpeg based source library for easy frame accurate access"
HOMEPAGE="https://github.com/FFMS/ffms2"
EGIT_REPO_URI="https://github.com/FFMS/ffms2.git"

LICENSE="MIT"
SLOT="0/4"
KEYWORDS=""
IUSE="libav static-libs"

RDEPEND="
	sys-libs/zlib
	!libav? ( >=media-video/ffmpeg-2.4:0= )
	libav? ( >=media-video/libav-9:0= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != "binary" ]] && ! test-flag-CXX -std=c++11; then
		die "Your compiler lacks C++11 support. Use GCC>=4.7.0 or Clang>=3.3."
	fi
}
