# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools git-r3

DESCRIPTION="automated testing of Operating Systems"
HOMEPAGE="http://os-autoinst.org/"
EGIT_REPO_URI="https://github.com/os-autoinst/os-autoinst.git"

LICENSE="GPL-2"
SLOT="0"

DEPEND="
	media-libs/libogg:=
	media-libs/libsndfile:=
	media-libs/libtheora:=
	>=media-libs/opencv-2.4:=
	sci-libs/fftw:3.0="
RDEPEND="${DEPEND}
	dev-lang/perl[ithreads]
	dev-perl/JSON
	app-emulation/qemu
	app-text/gocr
	media-gfx/imagemagick
	media-video/ffmpeg2theora"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
