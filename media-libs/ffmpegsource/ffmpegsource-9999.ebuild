# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils flag-o-matic git-r3 ltprune

DESCRIPTION="A libav/ffmpeg based source library for easy frame accurate access"
HOMEPAGE="https://github.com/FFMS/ffms2"
EGIT_REPO_URI="https://github.com/FFMS/ffms2.git"

LICENSE="MIT"
SLOT="0/4"
KEYWORDS=""

RDEPEND="
	sys-libs/zlib
	>=media-video/ffmpeg-2.4:0=
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

ffms_check_compiler() {
	if [[ ${MERGE_TYPE} != "binary" ]] && ! test-flag-CXX -std=c++11; then
		die "Your compiler lacks C++11 support. Use GCC>=4.7.0 or Clang>=3.3."
	fi
}

pkg_pretend() {
	ffms_check_compiler
}

pkg_setup() {
	ffms_check_compiler
}

src_prepare() {
	mkdir -p "${S}/src/config"
	default_src_prepare
	eautoreconf
}

src_install() {
	default_src_install
	prune_libtool_files
}
