# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit eutils python-any-r1 toolchain-funcs games

MY_PV="${PV/.}"

DESCRIPTION="Multiple Arcade Machine Emulator + Multi Emulator Super System (MESS)"
HOMEPAGE="http://mamedev.org/"
SRC_URI="https://github.com/mamedev/mame/releases/download/mame${MY_PV}/mame${MY_PV}s.zip -> mame-${PV}.zip"

LICENSE="XMAME"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="X alsa +arcade debug +mess opengl tools"
REQUIRED_USE="|| ( arcade mess )
		debug? ( X )"

# MESS (games-emulation/sdlmess) has been merged into MAME upstream since mame-0.162 (see below)
#  MAME/MESS build combined (default)	+arcade +mess	(mame)
#  MAME build only			+arcade -mess	(mamearcade)
#  MESS build only			-arcade +mess	(mess)
# games-emulation/sdlmametools is dropped and enabled instead by the 'tools' useflag
RDEPEND="!games-emulation/sdlmametools
	!games-emulation/sdlmess
	dev-db/sqlite:3
	dev-libs/expat
	media-libs/fontconfig
	media-libs/flac
	media-libs/libsdl2[joystick,opengl?,sound,video]
	media-libs/portaudio
	media-libs/sdl2-ttf
	sys-libs/zlib
	virtual/jpeg:0
	alsa? ( media-libs/alsa-lib
		media-libs/portmidi )
	debug? ( dev-qt/qtcore:4
		dev-qt/qtgui:4 )
	X? ( x11-libs/libX11
		x11-libs/libXinerama )
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	app-arch/unzip
	virtual/pkgconfig
	X? ( x11-proto/xineramaproto )"

S=${WORKDIR}

# Function to disable a makefile option
disable_feature() {
	sed -i -e "/$1.*=/s:^:# :" makefile || die
}

# Function to enable a makefile option
enable_feature() {
	sed -i -e "/^#.*$1.*=/s:^#::"  makefile || die
}

pkg_setup() {
	games_pkg_setup
	python-any-r1_pkg_setup
}

src_unpack() {
	default
	unpack ./mame.zip
	rm -f mame.zip || die
}

src_prepare() {
	# Disable using bundled libraries
	enable_feature USE_SYSTEM_LIB_EXPAT
	enable_feature USE_SYSTEM_LIB_FLAC
	enable_feature USE_SYSTEM_LIB_JPEG
# Use bundled lua for now to ensure correct compilation (ref. b.g.o #407091)
#	enable_feature USE_SYSTEM_LIB_LUA
	enable_feature USE_SYSTEM_LIB_PORTAUDIO
	enable_feature USE_SYSTEM_LIB_SQLITE3
	enable_feature USE_SYSTEM_LIB_ZLIB

	# Disable warnings being treated as errors and enable verbose build output
	enable_feature NOWERROR
	enable_feature VERBOSE

	use amd64 && enable_feature PTR64
	use ppc && enable_feature BIGENDIAN
	use debug && enable_feature DEBUG
	use opengl || enable_feature NO_OPENGL
	use tools && enable_feature TOOLS
	use X || enable_feature NO_X11

	if use alsa ; then
		enable_feature USE_SYSTEM_LIB_PORTMIDI
	else
		enable_feature NO_USE_MIDI
	fi

	sed -i \
		-e 's/-Os//' \
		-e '/^\(CC\|CXX\|AR\) /s/=/?=/' \
		3rdparty/genie/build/gmake.linux/genie.make || die
}

src_compile() {
	local targetargs
	local qtdebug=$(usex debug 1 0)

	use arcade && ! use mess && targetargs="SUBTARGET=arcade"
	! use arcade && use mess && targetargs="SUBTARGET=mess"

	function my_emake() {
		# Workaround conflicting $ARCH variable used by both Gentoo's
		# portage and by Mame's build scripts
		# turn off bgfx for now since it's an embedded library (bug #556642)
		PYTHON_EXECUTABLE=${PYTHON} \
		OVERRIDE_CC=$(tc-getCC) \
		OVERRIDE_CXX=$(tc-getCXX) \
		OVERRIDE_LD=$(tc-getCXX) \
		USE_BGFX=0 \
		ARCH= \
			emake "$@" \
				AR=$(tc-getAR)
	}
	my_emake -j1 generate

	my_emake ${targetargs} \
		SDL_INI_PATH="\$\$\$\$HOME/.sdlmame;${GAMES_SYSCONFDIR}/${PN}" \
		USE_QTDEBUG=${qtdebug}

	if use tools ; then
		my_emake -j1 TARGET=ldplayer USE_QTDEBUG=${qtdebug}
	fi
}

src_install() {
	local MAMEBIN
	local suffix="$(use amd64 && echo 64)$(use debug && echo d)"
	local f

	function mess_install() {
		dosym ${MAMEBIN} "${GAMES_BINDIR}"/mess${suffix}
		dosym ${MAMEBIN} "${GAMES_BINDIR}"/sdlmess
		newman src/osd/sdl/man/mess.6 sdlmess.6
		doman src/osd/sdl/man/mess.6
	}
	if use arcade ; then
		if use mess ; then
			MAMEBIN="mame${suffix}"
			mess_install
		else
			MAMEBIN="mamearcade${suffix}"
		fi
		doman src/osd/sdl/man/mame.6
		newman src/osd/sdl/man/mame.6 ${PN}.6
	elif use mess ; then
		MAMEBIN="mess${suffix}"
		mess_install
	fi
	dogamesbin ${MAMEBIN}
	dosym ${MAMEBIN} "${GAMES_BINDIR}/${PN}"

	insinto "${GAMES_DATADIR}/${PN}"
	doins -r src/osd/sdl/keymaps $(use mess && echo hash)

	# Create default mame.ini and inject Gentoo settings into it
	#  Note that '~' does not work and '$HOME' must be used
	./${MAMEBIN} -noreadconfig -showconfig > "${T}/mame.ini" || die
	# -- Paths --
	for f in {rom,hash,sample,art,font,crosshair} ; do
		sed -i \
			-e "s:\(${f}path\)[ \t]*\(.*\):\1 \t\t\$HOME/.${PN}/\2;${GAMES_DATADIR}/${PN}/\2:" \
			"${T}/mame.ini" || die
	done
	for f in {ctrlr,cheat} ; do
		sed -i \
			-e "s:\(${f}path\)[ \t]*\(.*\):\1 \t\t\$HOME/.${PN}/\2;${GAMES_SYSCONFDIR}/${PN}/\2;${GAMES_DATADIR}/${PN}/\2:" \
			"${T}/mame.ini" || die
	done
	# -- Directories
	for f in {cfg,nvram,memcard,input,state,snapshot,diff,comment} ; do
		sed -i \
			-e "s:\(${f}_directory\)[ \t]*\(.*\):\1 \t\t\$HOME/.${PN}/\2:" \
			"${T}/mame.ini" || die
	done
	# -- Keymaps --
	sed -i \
		-e "s:\(keymap_file\)[ \t]*\(.*\):\1 \t\t\$HOME/.${PN}/\2:" \
		"${T}/mame.ini" || die
	for f in src/osd/sdl/keymaps/km*.txt ; do
		sed -i \
			-e "/^keymap_file/a \#keymap_file \t\t${GAMES_DATADIR}/${PN}/keymaps/${f##*/}" \
			"${T}/mame.ini" || die
	done
	insinto "${GAMES_SYSCONFDIR}/${PN}"
	doins "${T}/mame.ini"

	insinto "${GAMES_SYSCONFDIR}/${PN}"
	doins "${FILESDIR}/vector.ini"

	dodoc docs/{config,mame,newvideo}.txt
	keepdir \
		"${GAMES_DATADIR}/${PN}"/{ctrlr,cheat,roms,samples,artwork,crosshair} \
		"${GAMES_SYSCONFDIR}/${PN}"/{ctrlr,cheat}

	if use tools ; then
		for f in castool chdman floptool imgtool jedutil ldresample ldverify romcmp testkeys ; do
			newgamesbin ${f} ${PN}-${f}
			newman src/osd/sdl/man/${f}.1 ${PN}-${f}.1
		done
		newgamesbin ldplayer${suffix} ${PN}-ldplayer
		newman src/osd/sdl/man/ldplayer.1 ${PN}-ldplayer.1
	fi

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	elog "It is strongly recommended to change either the system-wide"
	elog "  ${GAMES_SYSCONFDIR}/${PN}/mame.ini or use a per-user setup at ~/.${PN}/mame.ini"
	elog
	if use opengl ; then
		elog "You built ${PN} with opengl support and should set"
		elog "\"video\" to \"opengl\" in mame.ini to take advantage of that"
		elog
		elog "For more info see http://wiki.mamedev.org"
	fi
}
