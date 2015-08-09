# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit games autotools eutils

DESCRIPTION="Atari 800 emulator"
HOMEPAGE="http://atari800.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://sourceforge/${PN}/xf25.zip"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="ncurses oss opengl readline +sdl +sound"

NOTSDL_DEPS="
	sys-libs/ncurses
	sound? (
		!oss? ( media-libs/libsdl[sound] )
	)"
RDEPEND="sdl? ( >=media-libs/libsdl-1.2.0[opengl?,sound?,video] )
	ncurses? ( ${NOTSDL_DEPS} )
	!sdl? ( !ncurses? ( ${NOTSDL_DEPS} ) )
	readline? ( sys-libs/readline:0
		sys-libs/ncurses )
	media-libs/libpng:0
	sys-libs/zlib"
DEPEND="${RDEPEND}
	app-arch/unzip"

src_prepare() {
	# remove some not-so-interesting ones
	rm -f DOC/{INSTALL.*,*.in,CHANGES.OLD} || die
	sed -i \
		-e '1s/ 1 / 6 /' \
		src/atari800.man || die
	sed -i \
		-e "/SYSTEM_WIDE_CFG_FILE/s:/etc:${GAMES_SYSCONFDIR}:" \
		src/cfg.c || die
	sed -i \
		-e "/share/s:/usr/share:${GAMES_DATADIR}:" \
		src/atari.c || die
	sed "s:/usr/share/games:${GAMES_DATADIR}:" \
		"${FILESDIR}"/atari800.cfg > "${T}"/atari800.cfg || die

	# Bug 544608
	epatch "${FILESDIR}/${P}-tgetent-detection.patch"
	pushd src > /dev/null && eautoreconf
	popd > /dev/null
}

src_configure() {
	local video="ncurses"
	local sound=no

	use sdl && video="sdl"
	if use sound ; then
		if use sdl ; then
			sound=sdl
		elif use oss ; then
			sound=oss
		else
			echo
			elog "Sound requested but neither sdl nor oss specified."
			elog "Disabling sound suport."
		fi
	fi

	echo
	elog "Building ${PN} with ${video} video and ${sound} sound"
	echo

	cd src && \
		egamesconf \
			$(use_with readline) \
			--with-video=${video} \
			--with-sound=${sound}
}

src_compile() {
	emake -C src
}

src_install () {
	dogamesbin src/atari800
	newman src/atari800.man atari800.6
	dodoc README.1ST DOC/*
	insinto "${GAMES_DATADIR}/${PN}"
	doins "${WORKDIR}/"*.ROM
	insinto "${GAMES_SYSCONFDIR}"
	doins "${T}"/atari800.cfg
	prepgamesdirs
}
