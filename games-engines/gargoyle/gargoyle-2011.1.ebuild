# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# Regarding licenses: libgarglk is licensed under the GPLv2. Bundled
# interpreters are licensed under GPLv2, BSD or MIT license, except:
#   - glulxe: custom license, see "terps/glulxle/README"
#   - hugo: custom license, see "licenses/HUGO License.txt"
# Since we don't compile or install any of the bundled fonts, their licenses
# don't apply. (Fonts are installed through dependencies instead.)

EAPI=5
inherit eutils multiprocessing toolchain-funcs gnome2-utils games

DESCRIPTION="An Interactive Fiction (IF) player supporting all major formats"
HOMEPAGE="http://ccxvii.net/gargoyle/"
SRC_URI="https://garglk.googlecode.com/files/${P}-sources.zip"

LICENSE="BSD GPL-2 MIT Hugo Glulxe"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	>=media-fonts/libertine-5
	media-fonts/liberation-fonts
	media-libs/freetype:2
	media-libs/libpng:0
	media-libs/sdl-mixer
	media-libs/sdl-sound[modplug,mp3,vorbis]
	sys-libs/zlib
	virtual/jpeg:0
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-util/ftjam
	virtual/pkgconfig"

S=${WORKDIR}

src_prepare() {
	# Substitute custom CFLAGS/LDFLAGS.
	sed -i -e \
		"/^\s*OPTIM = / {
			s/ \(-O.*\)\? ;/ ;/
			a LINKFLAGS = ${LDFLAGS} ;
			a SHRLINKFLAGS = ${LDFLAGS} ;
		}" Jamrules || die

	# Don't link against libraries used indirectly through SDL_sound.
	sed -i -e "/GARGLKLIBS/s/-lsmpeg -lvorbisfile//g" Jamrules || die

	# Convert garglk.ini to UNIX format.
	edos2unix garglk/garglk.ini

	# The font name of Linux Libertine changed in version 5.
	sed -i -e 's/Linux Libertine O/Linux Libertine/g' garglk/garglk.ini || die

	epatch "${FILESDIR}"/${P}-desktopfile.patch
}

src_compile() {
	# build system messes up flags and toolchain completely
	# append flags to compiler commands to have consistent behavior
	jam \
		-sAR="$(tc-getAR) cru" \
		-sCC="$(tc-getCC) ${CFLAGS}" \
		-sCCFLAGS="" \
		-sC++="$(tc-getCXX) ${CXXFLAGS}" \
		-sCXX="$(tc-getCXX) ${CXXFLAGS}" \
		-sC++FLAGS="" \
		-sGARGLKINI="${GAMES_SYSCONFDIR}/garglk.ini" \
		-sUSESDL=yes \
		-sBUNDLEFONTS=no \
		-dx \
		-j$(makeopts_jobs) || die
}

src_install() {
	DESTDIR="${D}" \
	_BINDIR="${GAMES_PREFIX}/libexec/${PN}" \
	_APPDIR="${GAMES_PREFIX}/libexec/${PN}" \
	_LIBDIR="$(games_get_libdir)" \
	EXEMODE=755 \
	FILEMODE=755 \
	jam install || die

	# Install config file.
	insinto "${GAMES_SYSCONFDIR}"
	newins garglk/garglk.ini garglk.ini

	# Install application entry and icon.
	domenu garglk/${PN}.desktop
	doicon -s 32 garglk/${PN}-house.png

	# Symlink binaries to avoid name clashes.
	for terp in advsys agility alan2 alan3 frotz geas git glulxe hugo jacl \
		level9 magnetic nitfol scare tadsr
	do
		dosym "${GAMES_PREFIX}/libexec/${PN}/${terp}" \
			"${GAMES_BINDIR}/${PN}-${terp}"
	done

	# Also symlink the main binary since it resides in libexec.
	dosym "${GAMES_PREFIX}/libexec/${PN}/${PN}" \
		"${GAMES_BINDIR}/${PN}"

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
