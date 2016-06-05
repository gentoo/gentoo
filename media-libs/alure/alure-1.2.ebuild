# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit cmake-utils eutils

DESCRIPTION="The OpenAL Utility Toolkit"
HOMEPAGE="http://kcat.strangesoft.net/alure.html"
SRC_URI="http://kcat.strangesoft.net/alure-releases/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="dumb examples flac fluidsynth mp3 sndfile static-libs vorbis"

RDEPEND=">=media-libs/openal-1.1
	dumb? ( media-libs/dumb )
	flac? ( media-libs/flac )
	fluidsynth? ( >=media-sound/fluidsynth-1.1.1 )
	mp3? ( media-sound/mpg123 )
	sndfile? ( media-libs/libsndfile )
	vorbis? ( media-libs/libvorbis )"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-include-unistd.patch"
	sed -i -e "/DESTINATION/s:doc/alure:doc/${PF}:" CMakeLists.txt || die
}

src_configure() {
	# FIXME: libmodplug/sndfile.h from libmodplug conflict with sndfile.h from libsndfile
	local mycmakeargs=(
		$(cmake-utils_use dumb)
		$(cmake-utils_use_build examples)
		$(cmake-utils_use flac)
		$(cmake-utils_use fluidsynth)
		-DMODPLUG=OFF
		$(cmake-utils_use mp3 MPG123)
		$(cmake-utils_use sndfile)
		$(cmake-utils_use_build static-libs STATIC)
		$(cmake-utils_use vorbis)
		)

	cmake-utils_src_configure
}
