# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Regarding licenses: libgarglk is licensed under the GPLv2. Bundled
# interpreters are licensed under GPLv2, BSD or MIT license, except:
#   - glulxe: custom license, see "terps/glulxle/README"
#   - hugo: custom license, see "licenses/HUGO License.txt"
# Since we don't compile or install any of the bundled fonts, their licenses
# don't apply. (Fonts are installed through dependencies instead.)

EAPI=7

inherit desktop edos2unix flag-o-matic multiprocessing toolchain-funcs xdg

DESCRIPTION="An Interactive Fiction (IF) player supporting all major formats"
HOMEPAGE="http://ccxvii.net/gargoyle/"
SRC_URI="https://github.com/garglk/garglk/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD GPL-2 MIT Hugo Glulxe"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-fonts/libertine
	media-fonts/liberation-fonts
	media-libs/freetype:2
	media-libs/libpng:0
	media-libs/sdl-mixer
	media-libs/sdl-sound[modplug,mp3,vorbis]
	sys-libs/zlib
	virtual/jpeg:0
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEBD="
	app-arch/unzip
	dev-util/ftjam
	virtual/pkgconfig"

S="${WORKDIR}/garglk-${PV}"

PATCHES=(
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-QA-desktop.patch
)

src_prepare() {
	default
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

	append-cflags -std=gnu89 # build with gcc5 (bug #573378)
	append-cxxflags -std=gnu++11 # code assumes C++11 semantics (bug #642996)
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
		-sGARGLKINI="/etc/garglk.ini" \
		-sUSESDL=yes \
		-sBUNDLEFONTS=no \
		-dx \
		-j$(makeopts_jobs) || die
}

src_install() {
	DESTDIR="${D}" \
	_BINDIR="${EPREFIX}/usr/libexec/${PN}" \
	_APPDIR="${EPREFIX}/usr/libexec/${PN}" \
	_LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
	EXEMODE=755 \
	FILEMODE=755 \
	jam install || die

	# Install config file.
	insinto /etc
	newins garglk/garglk.ini garglk.ini

	# Install application entry and icon.
	domenu garglk/${PN}.desktop
	doicon -s 32 garglk/${PN}-house.png

	# Symlink binaries to avoid name clashes.
	local terp
	for terp in advsys agility alan2 alan3 bocfel frotz geas git glulxe hugo jacl \
		level9 magnetic nitfol scare scott tadsr; do
		dosym ../libexec/${PN}/${terp} /usr/bin/${PN}-${terp}
	done

	# Also symlink the main binary since it resides in libexec.
	dosym ../libexec/${PN}/${PN} /usr/bin/${PN}
}
