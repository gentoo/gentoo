# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="A clone of Transport Tycoon Deluxe"
HOMEPAGE="https://www.openttd.org/"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/OpenTTD/OpenTTD"
	inherit git-r3
else
	SRC_URI="https://cdn.openttd.org/openttd-releases/${PV}/${P}-source.tar.xz"

	KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="allegro cpu_flags_x86_sse debug dedicated +fluidsynth icu +lzma lzo +openmedia +png +sdl timidity +truetype +zlib"
REQUIRED_USE="!dedicated? ( || ( allegro sdl ) )"

RDEPEND="
	net-misc/curl
	dedicated? (
		acct-group/openttd
		acct-user/openttd
		app-misc/dtach
	)
	!dedicated? (
		media-libs/libogg
		media-libs/opusfile
		allegro? ( media-libs/allegro:5 )
		fluidsynth? ( media-sound/fluidsynth )
		icu? (
			>=dev-libs/icu-58.1:=
			media-libs/harfbuzz
		)
		sdl? ( media-libs/libsdl2[sound,video] )
		truetype? (
			media-libs/fontconfig
			media-libs/freetype:2
			virtual/zlib:=
		)
	)
	lzma? ( app-arch/xz-utils )
	lzo? ( dev-libs/lzo:2 )
	png? ( media-libs/libpng:= )
	zlib? ( virtual/zlib:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=games-util/grfcodec-6.0.6_p20210310
	virtual/pkgconfig
"
PDEPEND="
	!dedicated? (
		openmedia? (
			>=games-misc/openmsx-0.4.0
			>=games-misc/opensfx-1.0.1
		)
	)
	openmedia? ( >=games-misc/opengfx-0.6.1 )
	timidity? ( media-sound/timidity++ )
"

DOCS=( docs/directory_structure.md )

PATCHES=(
	"${FILESDIR}/${PN}-1.11.2_dont_compress_man.patch"
)

src_prepare() {
	# Drop automagic LTO usage
	sed -i -e '/check_ipo_supported(RESULT IPO_FOUND)/d' CMakeLists.txt || die

	# Don't force _FORTIFY_SOURCE via CMake
	# (we already set it in the toolchain by default with a minimum level
	# of _FORTIFY_SOURCE=2)
	sed -i -e '/-D_FORTIFY_SOURCE/d' cmake/CompileFlags.cmake || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_BINDIR=bin
		-DCMAKE_INSTALL_DATADIR=share
		-DOPTION_DEDICATED=$(usex dedicated)
		-DOPTION_USE_ASSERTS=$(usex debug)
		-DCMAKE_DISABLE_FIND_PACKAGE_Allegro=$(usex !allegro)
		-DCMAKE_DISABLE_FIND_PACKAGE_Freetype=$(usex !truetype)
		-DCMAKE_DISABLE_FIND_PACKAGE_Fontconfig=$(usex !truetype)
		-DCMAKE_DISABLE_FIND_PACKAGE_Fluidsynth=$(usex !fluidsynth)
		-DCMAKE_DISABLE_FIND_PACKAGE_ICU=$(usex !icu)
		-DCMAKE_DISABLE_FIND_PACKAGE_Harfbuzz=$(usex !icu)
		-DCMAKE_DISABLE_FIND_PACKAGE_LibLZMA=$(usex !lzma)
		-DCMAKE_DISABLE_FIND_PACKAGE_LZO=$(usex !lzo)
		-DCMAKE_DISABLE_FIND_PACKAGE_PNG=$(usex !png)
		-DCMAKE_DISABLE_FIND_PACKAGE_SDL2=$(usex !sdl)
		-DCMAKE_DISABLE_FIND_PACKAGE_SSE=$(usex !cpu_flags_x86_sse)
		-DCMAKE_DISABLE_FIND_PACKAGE_ZLIB=$(usex !zlib)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use dedicated ; then
		newconfd "${FILESDIR}"/openttd.confd-r1 openttd
		newinitd "${FILESDIR}"/openttd.initd-r3 openttd
	fi
}

pkg_postinst() {
	xdg_pkg_postinst

	if ! use openmedia ; then
		elog
		elog "OpenTTD was compiled without the 'openmedia' USE flag."
		elog
		elog "In order to play, you must at least install"
		elog "games-misc/opengfx, and games-misc/opensfx, or copy the "
		elog "following 6 files from a version of Transport Tycoon Deluxe"
		elog "(Windows or DOS) to shared or personal location."
		elog "See ${EROOT}/usr/share/doc/${PF}/directory_structure.md for more info."
		elog
		elog "From the Windows version you need: "
		elog "sample.cat trg1r.grf trgcr.grf trghr.grf trgir.grf trgtr.grf"
		elog "OR from the DOS version you need: "
		elog "SAMPLE.CAT TRG1.GRF TRGC.GRF TRGH.GRF TRGI.GRF TRGT.GRF"
	fi
}
