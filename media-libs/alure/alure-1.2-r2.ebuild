# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="The OpenAL Utility Toolkit"
HOMEPAGE="https://kcat.strangesoft.net/alure.html"
SRC_URI="https://kcat.strangesoft.net/alure-releases/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~x86"
IUSE="dumb examples flac fluidsynth mp3 sndfile static-libs vorbis"

RDEPEND="
	>=media-libs/openal-1.1
	dumb? ( media-libs/dumb:= )
	flac? ( media-libs/flac )
	fluidsynth? ( >=media-sound/fluidsynth-1.1.1:= )
	mp3? ( media-sound/mpg123 )
	sndfile? ( media-libs/libsndfile )
	vorbis? ( media-libs/libvorbis )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-include-unistd.patch
	"${FILESDIR}"/${P}-new-dumb.patch
)

src_prepare() {
	cmake_src_prepare

	sed -i -e "/DESTINATION/s:doc/alure:doc/${PF}:" CMakeLists.txt || die
}

src_configure() {
	# FIXME: libmodplug/sndfile.h from libmodplug conflict with sndfile.h from libsndfile
	local mycmakeargs=(
		-DMODPLUG=OFF
		-DDUMB=$(usex dumb)
		-DBUILD_EXAMPLES=$(usex examples)
		-DFLAC=$(usex flac)
		-DFLUIDSYNTH=$(usex fluidsynth)
		-DMPG123=$(usex mp3)
		-DSNDFILE=$(usex sndfile)
		-DBUILD_STATIC=$(usex static-libs)
		-DVORBIS=$(usex vorbis)
	)

	cmake_src_configure
}
