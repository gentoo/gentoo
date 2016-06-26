# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils scons-utils games

DV=2
MY_P=dxx-rebirth-${PV}-d2x
DESCRIPTION="Descent Rebirth - enhanced Descent ${DV} engine"
HOMEPAGE="http://www.dxx-rebirth.com/"
SRC_URI="https://github.com/dxx-rebirth/dxx-rebirth/archive/0.58.1-d2x.tar.gz -> ${P}.tar.gz
	opl3-musicpack? ( http://www.dxx-rebirth.com/download/dxx/res/d${DV}xr-opl3-music.zip )
	sc55-musicpack? ( http://www.dxx-rebirth.com/download/dxx/res/d${DV}xr-sc55-music.zip )
	l10n_de? ( http://www.dxx-rebirth.com/download/dxx/res/d${DV}xr-briefings-ger.zip )"

LICENSE="D1X GPL-2 public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="cdinstall debug demo ipv6 l10n_de +music opengl opl3-musicpack sc55-musicpack"
REQUIRED_USE="?? ( opl3-musicpack sc55-musicpack )
	opl3-musicpack? ( music )
	sc55-musicpack? ( music )"

RDEPEND="dev-games/physfs[hog,mvl,zip]
	media-libs/libsdl[X,sound,joystick,opengl?,video]
	music? (
		media-libs/sdl-mixer[timidity,vorbis]
	)
	opengl? (
		virtual/opengl
		virtual/glu
	)"
DEPEND="${RDEPEND}
	app-arch/unzip"
PDEPEND="cdinstall? ( games-action/descent2-data )
	demo? ( games-action/descent2-demodata )"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${P}.tar.gz
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-flags.patch

	DOCS=( {CHANGELOG,INSTALL,README,RELEASE-NOTES}.txt )
	edos2unix ${DOCS[@]}
}

src_compile() {
	escons \
		verbosebuild=1 \
		sharepath="${GAMES_DATADIR}/d${DV}x" \
		$(use_scons ipv6) \
		$(use_scons music sdlmixer) \
		$(use_scons debug) \
		$(use_scons opengl) \
		|| die
}

src_install() {
	dodoc ${DOCS[@]}

	insinto "${GAMES_DATADIR}/d${DV}x"

	# None of the following zip files need to be extracted.
	use l10n_de && newins "${DISTDIR}"/d${DV}xr-briefings-ger.zip d${DV}xr-briefings-ger.dxa
	use opl3-musicpack && newins "${DISTDIR}"/d${DV}xr-opl3-music.zip d${DV}xr-opl3-music.dxa
	use sc55-musicpack && newins "${DISTDIR}"/d${DV}xr-sc55-music.zip d${DV}xr-sc55-music.dxa

	doicon ${PN}.xpm

	dogamesbin ${PN}
	make_desktop_entry ${PN} "Descent ${DV} Rebirth"
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	if ! use cdinstall ; then
		echo
		elog "To play the full game enable USE=\"cdinstall\" or manually "
		elog "copy the files to ${GAMES_DATADIR}/d${DV}x."
		elog "See /usr/share/doc/${PF}/INSTALL.txt for details."
		echo
	fi
	elog 'AddOns now use filename extension ".dxa".'
	elog 'Your old AddOns will not work anymore.'
	elog 'You can either re-download them or simply'
	elog 'rename them from *.zip to *.dxa.'
}
