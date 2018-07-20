# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="Frontend for AdvanceMAME, MAME, MESS, RAINE and any other emulator"
HOMEPAGE="http://advancemame.sourceforge.net/menu-readme.html"
SRC_URI="mirror://sourceforge/advancemame/${P}.tar.gz"

# Too big to put into FILESDIR
SRC_URI+=" https://dev.gentoo.org/~polynomial-c/${PN}-2.9-use_pkgconfig_for_freetype_and_sdl.patch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa debug fbcon ncurses oss sdl slang truetype"

RDEPEND="dev-libs/expat
	alsa? ( media-libs/alsa-lib )
	ncurses? ( sys-libs/ncurses:0 )
	sdl? ( media-libs/libsdl )
	slang? ( >=sys-libs/slang-1.4 )
	!sdl? ( ( !fbcon? ( media-libs/libsdl ) ) )
	truetype? ( >=media-libs/freetype-2 )"
DEPEND="${RDEPEND}
	x86? ( >=dev-lang/nasm-0.98 )
	fbcon? ( virtual/os-headers )"

PATCHES=(
	# pic patch - bug #142021
	"${FILESDIR}"/${PN}-2.7-pic.patch
	"${FILESDIR}/${PN}-2.9-destdir.patch"
	"${DISTDIR}/${PN}-2.9-use_pkgconfig_for_freetype_and_sdl.patch"
)

src_prepare() {
	default
	sed -i -e 's/"-s"//' configure.ac || die

	use x86 && ln -s $(type -P nasm) "${T}/${CHOST}-nasm"
	eautoreconf
}

src_configure() {
	export PATH="${PATH}:${T}"
	local myeconfargs=(
		--enable-expat
		--enable-zlib
		--disable-svgalib
		$(use_enable alsa)
		$(use_enable debug)
		$(use_enable fbcon fb)
		$(use_enable ncurses)
		$(use_enable truetype freetype)
		$(use_enable oss)
		$(use_enable sdl)
		$(use_enable slang)
		$(use !sdl && use !fbcon && echo --enable-sdl)
		$(use_enable x86 asm)
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	STRIPPROG=true emake
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc HISTORY README RELEASE doc/*.txt
	doman doc/{advmenu,advdev}.1
	docinto html
	dodoc doc/*.html
}

pkg_postinst() {
	echo
	elog "Execute:"
	elog "     advmenu -default"
	elog "to generate a config file"
	elog
	elog "An example emulator config found in advmenu.rc:"
	elog "     emulator \"snes9x\" generic \"${GAMES_BINDIR}/snes9x\" \"%f\""
	elog "     emulator_roms \"snes9x\" \"/home/user/myroms\""
	elog "     emulator_roms_filter \"snes9x\" \"*.smc;*.sfc\""
	elog
	elog "For more information, see the advmenu man page."
}
