# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs xdg-utils

EGIT_COMMIT="e35219148"
MY_BUILD="$(ver_cut 2)"
MY_DATE="$(ver_cut 1)"
MY_PV_HRP="5.4"
MY_PV_OFFENSIVE_XXX="1.33"
MY_PV_OPL="2.01"
MY_PV_PSX="1.11"
MY_PV_SC55="4.02"
MY_PV_VOXELS="1.21"

DESCRIPTION="An open source engine port of the classic PC first person shooter Duke Nukem 3D"
HOMEPAGE="http://www.eduke32.com/"
SRC_URI="
	http://dukeworld.com/eduke32/synthesis/${MY_DATE}-${MY_BUILD}-${EGIT_COMMIT}/${PN}_src_${MY_DATE}-${MY_BUILD}-${EGIT_COMMIT}.tar.xz
	http://www.eduke32.com/images/eduke32_classic.png
	hrp? ( http://www.duke4.org/files/nightfright/hrp/duke3d_hrp.zip -> duke3d_hrp-${MY_PV_HRP}.zip )
	offensive? ( http://www.duke4.org/files/nightfright/related/duke3d_xxx.zip -> duke3d_xxx-${MY_PV_OFFENSIVE_XXX}.zip )
	opl? ( https://www.moddb.com/downloads/mirror/95750/102/ce9e8f422c6cccdb297852426e96740a -> duke3d_musopl-${MY_PV_OPL}.zip )
	psx? ( http://www.duke4.org/files/nightfright/related/duke3d_psx.zip -> duke3d_psx-${MY_PV_PSX}.zip )
	sc-55? ( http://www.duke4.org/files/nightfright/music/duke3d_music-sc55.zip -> duke3d_music-sc55-${MY_PV_SC55}.zip )
	voxels? ( https://www.dropbox.com/s/yaxfahyvskyvt4r/duke3d_voxels.zip -> duke3d_voxels-${MY_PV_VOXELS}.zip )
"
S="${WORKDIR}/${PN}_${MY_DATE}-${MY_BUILD}-${EGIT_COMMIT}"

LICENSE="BUILDLIC GPL-2 HRP"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="duke3d fluidsynth gtk hrp offensive opengl opl png psx sc-55 server sdk timidity tools voidsw voxels vpx xmp"
REQUIRED_USE="
	hrp? ( duke3d !voxels )
	offensive? ( duke3d )
	opl? ( duke3d !sc-55 )
	psx? ( duke3d )
	sc-55? ( duke3d !opl )
	voxels? ( !hrp )
	vpx? ( opengl )
"

# There are no tests,
# instead it tries to build a test game, which does not compile
RESTRICT="bindist test"

RDEPEND="
	media-libs/flac:=
	media-libs/libogg
	media-libs/libsdl2[alsa,joystick,opengl?,sound,video]
	media-libs/libvorbis
	media-libs/sdl2-mixer[flac,fluidsynth?,midi,timidity?,vorbis]
	sys-libs/zlib
	gtk? ( x11-libs/gtk+:2 )
	opengl? (
		virtual/glu
		virtual/opengl
	)
	png? ( media-libs/libpng:0= )
	vpx? ( media-libs/libvpx:= )
	xmp? ( media-libs/exempi:2= )
"

DEPEND="
	${RDEPEND}
	timidity? ( media-sound/timidity++ )
"

BDEPEND="
	app-arch/unzip
	x86? ( dev-lang/nasm )
"

PDEPEND="duke3d? ( games-fps/duke3d-data )"

PATCHES=(
	"${FILESDIR}/${PN}-20200505.8904-gcc10.patch"
	"${FILESDIR}/${PN}-20220204.9957-log-to-tmpdir.patch"
	"${FILESDIR}/${PN}-20230926.10459-search-duke3d-path.patch"
)

src_unpack() {
	# Extract only the eduke32 archive
	unpack ${PN}_src_${MY_DATE}-${MY_BUILD}-${EGIT_COMMIT}.tar.xz

	# Unpack only the documentation
	if use hrp; then
		unzip -q "${DISTDIR}"/duke3d_hrp-${MY_PV_HRP}.zip hrp_readme.txt hrp_todo.txt || die
	fi
	if use offensive; then
		unzip -q "${DISTDIR}"/duke3d_xxx-${MY_PV_OFFENSIVE_XXX}.zip xxx_readme.txt || die
	fi
	if use opl; then
		unzip -q "${DISTDIR}"/duke3d_musopl-${MY_PV_OPL}.zip readme.txt || die
		mv readme.txt opl_readme.txt || die
	fi
	if use sc-55; then
		unzip -q "${DISTDIR}"/duke3d_music-sc55-${MY_PV_SC55}.zip readme/music_readme.txt || die
	fi
	if use voxels; then
		unzip -q "${DISTDIR}"/duke3d_voxels-${MY_PV_VOXELS}.zip voxelpack_readme.txt || die
	fi
}

src_compile() {
	local myemakeopts=(
		ALLOCACHE_AS_MALLOC=0
		AS="$(tc-getAS)"
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		CLANG=0
		CPLUSPLUS=1
		CUSTOMOPT=""
		DEBUGANYWAY=0
		F_JUMP_TABLES=""
		FORCEDEBUG=0
		HAVE_FLAC=1
		HAVE_GTK2=$(usex gtk 1 0)
		HAVE_XMP=$(usex xmp 1 0)
		LINKED_GTK=$(usex gtk 1 0)
		LTO=1
		LUNATIC=0
		KRANDDEBUG=0
		MEMMAP=0
		MIXERTYPE=SDL
		NETCODE=$(usex server 1 0)
		NOASM=0
		OPTLEVEL=0
		OPTOPT=""
		PACKAGE_REPOSITORY=1
		POLYMER=$(usex opengl 1 0)
		PRETTY_OUTPUT=0
		PROFILER=0
		RELEASE=1
		RENDERTYPE=SDL
		SDL_TARGET=2
		SIMPLE_MENU=0
		STRIP=""
		STANDALONE=0
		STARTUP_WINDOW=$(usex gtk 1 0)
		USE_OPENGL=$(usex opengl 1 0)
		USE_LIBVPX=$(usex vpx 1 0)
		USE_LIBPNG=$(usex png 1 0)
		USE_LUAJIT_2_1=0
		WITHOUT_GTK=$(usex gtk 0 1)
	)

	emake "${myemakeopts[@]}"

	use tools && emake utils "${myemakeopts[@]}"
	use voidsw && emake sw "${myemakeopts[@]}"
}

src_install() {
	dobin eduke32 mapster32 "${FILESDIR}"/eduke32-bin
	use voidsw && dobin voidsw "${FILESDIR}"/voidsw-bin

	if use tools; then
		local tools=(
			arttool
			bsuite
			cacheinfo
			generateicon
			givedepth
			ivfrate
			kextract
			kgroup
			kmd2tool
			makesdlkeytrans
			map2stl
			md2tool
			mkpalette
			transpal
			unpackssi
			wad2art
			wad2map
		)

		dobin "${tools[@]}"
	fi

	keepdir /usr/share/games/eduke32
	insinto /usr/share/games/eduke32

	use hrp && doins "${DISTDIR}"/duke3d_hrp-${MY_PV_HRP}.zip
	use offensive && doins "${DISTDIR}"/duke3d_xxx-${MY_PV_OFFENSIVE_XXX}.zip
	use opl && doins "${DISTDIR}"/duke3d_musopl-${MY_PV_OPL}.zip
	use psx && doins "${DISTDIR}"/duke3d_psx-${MY_PV_PSX}.zip
	use sc-55 && doins "${DISTDIR}"/duke3d_music-sc55-${MY_PV_SC55}.zip
	use sdk && doins -r package/sdk
	use voxels && doins "${DISTDIR}"/duke3d_voxels-${MY_PV_VOXELS}.zip

	newicon "${DISTDIR}"/eduke32_classic.png eduke32.png

	make_desktop_entry eduke32-bin EDuke32 eduke32 Game
	make_desktop_entry mapster32 Mapster32 eduke32 Game
	use voidsw && make_desktop_entry voidsw-bin VoidSW voidsw Game

	local DOCS=( package/sdk/samples/*.txt source/build/doc/*.txt )
	use hrp && DOCS+=( "${WORKDIR}"/hrp_readme.txt "${WORKDIR}"/hrp_todo.txt )
	use offensive && DOCS+=( "${WORKDIR}"/xxx_readme.txt )
	use opl && DOCS+=( "${WORKDIR}"/opl_readme.txt )
	use sc-55 && DOCS+=( "${WORKDIR}"/readme/music_readme.txt )
	use voxels && DOCS+=( "${WORKDIR}"/voxelpack_readme.txt )

	einstalldocs
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
