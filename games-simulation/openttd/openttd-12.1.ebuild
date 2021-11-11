# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A clone of Transport Tycoon Deluxe"
HOMEPAGE="https://www.openttd.org/"
SRC_URI="https://cdn.openttd.org/openttd-releases/${PV}/${P}-source.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

IUSE="allegro cpu_flags_x86_sse dedicated +fluidsynth icu +lzma lzo +openmedia +png +sdl timidity +truetype +zlib"
REQUIRED_USE="!dedicated? ( || ( allegro sdl ) )"

RESTRICT="test" # needs a graphics set in order to test

RDEPEND="
	!dedicated? (
		allegro? ( media-libs/allegro:5 )
		fluidsynth? ( media-sound/fluidsynth )
		icu? (
			dev-libs/icu-layoutex:=
			dev-libs/icu-le-hb
			>=dev-libs/icu-58.1:=
		)
		sdl? ( media-libs/libsdl2[sound,video] )
		truetype? (
			media-libs/fontconfig
			media-libs/freetype:2
			sys-libs/zlib:=
		)
	)
	lzma? ( app-arch/xz-utils )
	lzo? ( dev-libs/lzo:2 )
	png? ( media-libs/libpng:0= )
	zlib? ( sys-libs/zlib:= )"
DEPEND="${RDEPEND}"
BDEPEND=">=games-util/grfcodec-6.0.6_p20210310
	virtual/pkgconfig"
PDEPEND="
	!dedicated? (
		openmedia? (
			>=games-misc/openmsx-0.4.0
			>=games-misc/opensfx-1.0.1
		)
	)
	openmedia? ( >=games-misc/opengfx-0.6.1 )
	timidity? ( media-sound/timidity++ )"

DOCS=( docs/directory_structure.md )
PATCHES=(
	"${FILESDIR}/${PN}-1.11.2_dont_compress_man.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_BINDIR=bin
		-DCMAKE_INSTALL_DATADIR=share
		-DOPTION_DEDICATED=$(usex dedicated)
		-DCMAKE_DISABLE_FIND_PACKAGE_Allegro=$(usex !allegro)
		-DCMAKE_DISABLE_FIND_PACKAGE_Freetype=$(usex !truetype)
		-DCMAKE_DISABLE_FIND_PACKAGE_Fontconfig=$(usex !truetype)
		-DCMAKE_DISABLE_FIND_PACKAGE_Fluidsynth=$(usex !fluidsynth)
		-DCMAKE_DISABLE_FIND_PACKAGE_ICU=$(usex !icu)
		-DCMAKE_DISABLE_FIND_PACKAGE_LibLZMA=$(usex !lzma)
		-DCMAKE_DISABLE_FIND_PACKAGE_LZO=$(usex !lzo)
		-DCMAKE_DISABLE_FIND_PACKAGE_PNG=$(usex !png)
		# N.B. regarding #807364: CMAKE_DISABLE_FIND_PACKAGE_SDL is used only
		# with USE="allegro -sdl" combination flags. There no other way to
		# completely disable SDL1 support.
		-DCMAKE_DISABLE_FIND_PACKAGE_SDL=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_SDL2=$(usex !sdl)
		-DCMAKE_DISABLE_FIND_PACKAGE_SSE=$(usex !cpu_flags_x86_sse)
		-DCMAKE_DISABLE_FIND_PACKAGE_ZLIB=$(usex !zlib)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	newinitd "${FILESDIR}"/${PN}.initd-r1 ${PN}
}

pkg_postinst() {
	if ! use openmedia ; then
		elog
		elog "OpenTTD was compiled without the 'openmedia' USE flag."
		elog
		elog "In order to play, you must at least install"
		elog "games-misc/opengfx, and games-misc/opensfx, or copy the "
		elog "following 6 files from a version of Transport Tycoon Deluxe"
		elog "(Windows or DOS) to shared or personal location."
		elog "See /usr/share/doc/${PF}/directory_structure.md for more info."
		elog
		elog "From the Windows version you need: "
		elog "sample.cat trg1r.grf trgcr.grf trghr.grf trgir.grf trgtr.grf"
		elog "OR from the DOS version you need: "
		elog "SAMPLE.CAT TRG1.GRF TRGC.GRF TRGH.GRF TRGI.GRF TRGT.GRF"
	fi
}
