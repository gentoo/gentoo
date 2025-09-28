# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="GNU/Linux port of the MAME emulator with GUI menu"
HOMEPAGE="https://www.advancemame.it/"
SRC_URI="https://github.com/amadvance/advancemame/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2 XMAME"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="alsa fbcon ncurses openmp oss +sdl slang truetype"

REQUIRED_USE="
	|| ( fbcon sdl )
	|| ( alsa oss sdl )
"

DEPEND="
	dev-libs/expat
	sys-libs/zlib
	alsa? ( media-libs/alsa-lib )
	ncurses? ( sys-libs/ncurses:= )
	sdl? ( media-libs/libsdl2[video] )
	slang? ( sys-libs/slang )
	truetype? ( media-libs/freetype:2 )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-build/autoconf-archive
	virtual/pkgconfig
	x86? ( >=dev-lang/nasm-0.98 )
"

PATCHES=(
	"${FILESDIR}"/${PN}-pic.patch
	"${FILESDIR}"/${PN}-verboselog.patch
	"${FILESDIR}"/${P}-docdir.patch
)

check_openmp() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_pretend() {
	check_openmp
}

pkg_setup() {
	check_openmp
}

src_prepare() {
	default

	# AC_CHECK_CC_OPT is obsolete, superseded by AX_CHECK_COMPILE_FLAG
	sed -i -e 's/AC_CHECK_CC_OPT/AX_CHECK_COMPILE_FLAG/' configure.ac || die

	eautoreconf
}

src_configure() {
	# https://bugs.gentoo.org/858626
	#
	# From upstream configure.ac, only enabled if CFLAGS is not set:
	# - Code was written when compilers were not aggressively optimizing undefined behaviour about aliasing
	# - Code was written when compilers were not aggressively optimizing undefined behaviour about overflow in signed integers
	# - Code was written on Intel where char is signed
	#
	# Do not trust with LTO either, BTW
	append-flags -fno-strict-aliasing -fno-strict-overflow -fsigned-char
	filter-lto

	# Fix for bug #78030
	use ppc && append-ldflags "-Wl,--relax"

	ac_cv_prog_ASM=nasm \
	econf \
		--enable-expat \
		--disable-sdl \
		--enable-zlib \
		--disable-svgalib \
		$(use_enable alsa) \
		$(use_enable fbcon fb) \
		$(use_enable ncurses) \
		$(use_enable openmp) \
		$(use_enable oss) \
		$(use_enable sdl sdl2) \
		$(use_enable slang) \
		$(use_enable truetype freetype) \
		$(use_enable x86 asm)
}

src_compile() {
	emake \
		VERSION="${PV}"
}

src_install() {
	emake -j1 install \
		VERSION="${PV}" \
		DESTDIR="${D}"
}
