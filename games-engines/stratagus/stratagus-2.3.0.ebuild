# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils eutils games

DESCRIPTION="A realtime strategy game engine"
HOMEPAGE="https://launchpad.net/stratagus/"
SRC_URI="https://launchpad.net/stratagus/trunk/2.3/+download/stratagus_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bzip2 debug doc fluidsynth mikmod mng theora vorbis"

RDEPEND="dev-db/sqlite:3
	>=dev-lang/lua-5:0
	dev-lua/toluapp
	media-libs/libpng:0
	virtual/opengl
	x11-libs/libX11
	media-libs/libsdl[sound,opengl,video]
	sys-libs/zlib
	bzip2? ( app-arch/bzip2 )
	fluidsynth? ( media-sound/fluidsynth )
	mikmod? ( media-libs/libmikmod )
	mng? ( media-libs/libmng )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
		theora? ( media-libs/libtheora )
	)"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig"

REQUIRED_USE="theora? ( vorbis )"
PATCHES=( "${FILESDIR}"/${P}-{debug,doc}.patch )

S=${WORKDIR}/${PN}_${PV}.orig

src_configure() {
	# there are in-source switches
	use debug && CMAKE_BUILD_TYPE=Debug

	local mycmakeargs=(
		-DGAMEDIR="${GAMES_BINDIR}"
		-DBINDIR="${GAMES_BINDIR}"
		-DSBINDIR="${GAMES_BINDIR}"
		-DDOCDIR="/usr/share/doc/${PF}"
		$(cmake-utils_use_with bzip2)
		$(cmake-utils_use_enable doc)
		$(cmake-utils_use_with fluidsynth)
		$(cmake-utils_use_with mikmod)
		$(cmake-utils_use_with mng)
		$(cmake-utils_use_with vorbis OGGVORBIS)
		$(cmake-utils_use_with theora)
		-DENABLE_DEV=ON
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	prepgamesdirs
}
