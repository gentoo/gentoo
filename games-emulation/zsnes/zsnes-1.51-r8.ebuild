# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools desktop flag-o-matic toolchain-funcs pax-utils

DESCRIPTION="SNES (Super Nintendo) emulator that uses x86 assembly"
HOMEPAGE="https://www.zsnes.com/ http://ipherswipsite.com/zsnes/"
SRC_URI="mirror://sourceforge/zsnes/${PN}${PV//./}src.tar.bz2 -> ${P}-20071031.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="ao custom-cflags +debug opengl png"

RDEPEND="
	media-libs/libsdl[sound,video,abi_x86_32(-)]
	>=sys-libs/zlib-1.2.3-r1[abi_x86_32(-)]
	ao? ( media-libs/libao[abi_x86_32(-)] )
	debug? ( sys-libs/ncurses:0=[abi_x86_32(-)] )
	opengl? ( virtual/opengl[abi_x86_32(-)] )
	png? ( media-libs/libpng:0=[abi_x86_32(-)] )
"
DEPEND="${RDEPEND}
	dev-lang/nasm
	debug? ( virtual/pkgconfig )
"

S="${WORKDIR}/${PN}_${PV//./_}/src"

PATCHES=(
	# Fixing compilation without libpng installed
	"${FILESDIR}"/${P}-libpng.patch

	# Fix bug #186111
	# Fix bug #214697
	# Fix bug #170108
	# Fix bug #260247
	"${FILESDIR}"/${P}-gcc43-20071031.patch
	"${FILESDIR}"/${P}-libao-thread.patch
	"${FILESDIR}"/${P}-depbuild.patch
	"${FILESDIR}"/${P}-CC-quotes.patch

	# Fix compability with libpng15 wrt #378735
	"${FILESDIR}"/${P}-libpng15.patch

	# Fix buffer overwrite #257963
	"${FILESDIR}"/${P}-buffer.patch
	# Fix gcc47 compile #419635
	"${FILESDIR}"/${P}-gcc47.patch
	# Fix stack alignment issue #503138
	"${FILESDIR}"/${P}-stack-align-v2.patch

	"${FILESDIR}"/${P}-cross-compile.patch
	"${FILESDIR}"/${P}-arch.patch

	"${FILESDIR}"/${P}-gcc-10.patch
)

src_prepare() {
	default

	# The sdl detection logic uses AC_PROG_PATH instead of
	# AC_PROG_TOOL, so force the var to get set the way we
	# need for things to work correctly.
	tc-is-cross-compiler && export ac_cv_path_SDL_CONFIG=${CHOST}-sdl-config

	sed -i -e '67i#define OF(x) x' zip/zunzip.h || die

	# Remove hardcoded CFLAGS and LDFLAGS
	sed -i \
		-e '/^CFLAGS=.*local/s:-pipe.*:-Wall -I.":' \
		-e '/^LDFLAGS=.*local/d' \
		-e '/\w*CFLAGS=.*fomit/s:-O3.*$STRIP::' \
		-e '/lncurses/s:-lncurses:`pkg-config ncurses --libs`:' \
		-e '/lcurses/s:-lcurses:`pkg-config ncurses --libs`:' \
		configure.in || die
	sed -i \
		-e 's/configure.in/configure.ac/' \
		Makefile.in || die
	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	tc-export CC
	export BUILD_CXX=$(tc-getBUILD_CXX)
	export NFLAGS=-O1
	use amd64 && multilib_toolchain_setup x86
	use custom-cflags || strip-flags

	append-cppflags -U_FORTIFY_SOURCE	#257963

	econf \
		$(use_enable ao libao) \
		$(use_enable debug debugger) \
		$(use_enable png libpng) \
		$(use_enable opengl) \
		--disable-debug \
		--disable-cpucheck
}

src_compile() {
	emake makefile.dep
	emake
}

src_install() {
	# Uses pic-unfriendly assembly code, bug #427104
	QA_TEXTRELS="usr/bin/zsnes"

	dobin zsnes
	pax-mark m "${ED}${GAMES_BINDIR}"/zsnes

	newman linux/zsnes.1 zsnes.6

	dodoc \
		../docs/{readme.1st,authors.txt,srcinfo.txt,stdards.txt,support.txt,thanks.txt,todo.txt,README.LINUX} \
		../docs/readme.txt/*
	HTML_DOCS="../docs/readme.htm/*" einstalldocs

	make_desktop_entry zsnes ZSNES
	newicon icons/48x48x32.png ${PN}.png
}
