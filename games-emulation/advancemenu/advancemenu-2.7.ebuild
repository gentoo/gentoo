# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils games

DESCRIPTION="Frontend for AdvanceMAME, MAME, MESS, RAINE and any other emulator"
HOMEPAGE="http://advancemame.sourceforge.net/menu-readme.html"
SRC_URI="mirror://sourceforge/advancemame/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="alsa debug fbcon ncurses oss sdl slang truetype"

RDEPEND="dev-libs/expat
	alsa? ( media-libs/alsa-lib )
	ncurses? ( sys-libs/ncurses )
	sdl? ( media-libs/libsdl )
	slang? ( >=sys-libs/slang-1.4 )
	!sdl? ( ( !fbcon? ( media-libs/libsdl ) ) )
	truetype? ( >=media-libs/freetype-2 )"
DEPEND="${RDEPEND}
	x86? ( >=dev-lang/nasm-0.98 )
	fbcon? ( virtual/os-headers )"

src_prepare() {
	# pic patch - bug #142021
	epatch \
		"${FILESDIR}"/${P}-alsa-pkg-config.patch \
		"${FILESDIR}"/${P}-pic.patch
	sed -i -e 's/"-s"//' configure.ac || die

	use x86 && ln -s $(type -P nasm) "${T}/${CHOST}-nasm"
	use sdl && ln -s $(type -P sdl-config) "${T}/${CHOST}-sdl-config"
	use !sdl && use !fbcon && ln -s $(type -P sdl-config) "${T}/${CHOST}-sdl-config"
	use truetype && ln -s $(type -P freetype-config) "${T}/${CHOST}-freetype-config"
	eautoreconf
}

src_configure() {
	export PATH="${PATH}:${T}"
	egamesconf \
		--enable-expat \
		--enable-zlib \
		--disable-svgalib \
		--disable-static \
		$(use_enable alsa) \
		$(use_enable debug) \
		$(use_enable fbcon fb) \
		$(use_enable ncurses) \
		$(use_enable truetype freetype) \
		$(use_enable oss) \
		$(use_enable sdl) \
		$(use_enable slang) \
		$(use !sdl && use !fbcon && echo --enable-sdl) \
		$(use_enable x86 asm)
}

src_compile() {
	STRIPPROG=true emake
}

src_install() {
	dogamesbin advmenu
	dodoc HISTORY README RELEASE doc/*.txt
	doman doc/{advmenu,advdev}.1
	dohtml doc/*.html
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
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
