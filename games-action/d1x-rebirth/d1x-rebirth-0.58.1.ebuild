# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
CDROM_OPTIONAL="yes"
inherit eutils cdrom scons-utils games

DV=1
MY_P=${PN}_v${PV}-src
DESCRIPTION="Descent Rebirth - enhanced Descent ${DV} engine"
HOMEPAGE="http://www.dxx-rebirth.com/"
SRC_URI="http://www.dxx-rebirth.com/download/dxx/${MY_P}.tar.gz
	http://www.dxx-rebirth.com/download/dxx/res/d1xrdata.zip
	http://www.dxx-rebirth.com/download/dxx/res/dxx-rebirth_icons.zip
	opl3-musicpack? ( http://www.dxx-rebirth.com/download/dxx/res/d${DV}xr-opl3-music.zip )
	sc55-musicpack? ( http://www.dxx-rebirth.com/download/dxx/res/d${DV}xr-sc55-music.zip )	cdinstall? ( http://www.dxx-rebirth.com/download/dxx/res/d1datapt.zip )
	linguas_de? ( http://www.dxx-rebirth.com/download/dxx/res/d${DV}xr-briefings-ger.zip )"

LICENSE="D1X GPL-2 public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="cdinstall debug demo ipv6 linguas_de +music opengl opl3-musicpack sc55-musicpack"
REQUIRED_USE="?? ( cdinstall demo )
	?? ( opl3-musicpack sc55-musicpack )
	opl3-musicpack? ( music )
	sc55-musicpack? ( music )"

RDEPEND="dev-games/physfs[hog,zip]
	media-libs/libsdl[X,sound,joystick,opengl?,video]
	cdinstall? ( !games-action/descent1-demodata )
	music? (
		media-libs/sdl-mixer[timidity]
	)
	opengl? (
		virtual/opengl
		virtual/glu
	)"
DEPEND="${RDEPEND}
	app-arch/unzip"
PDEPEND="demo? ( games-action/descent1-demodata )"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${MY_P}.tar.gz dxx-rebirth_icons.zip
	if use cdinstall ; then
		unpack d1datapt.zip
		cdrom_get_cds descent/descent.hog
		mkdir "${S}"/Data
		cp \
			${CDROM_ROOT}/descent/descent.{hog,pig} \
			${CDROM_ROOT}/descent/chaos.{hog,msn} \
			"${S}"/Data || die
	fi
}

src_prepare() {
	if use cdinstall ; then
		cd Data
		patch -p0 < "${WORKDIR}"/d1datapt/descent.hog.diff descent.hog
		patch -p0 < "${WORKDIR}"/d1datapt/descent.pig.diff descent.pig
	fi
	epatch "${FILESDIR}"/${P}-flags.patch
}

src_compile() {
	escons \
		verbosebuild=1 \
		sharepath="${GAMES_DATADIR}/d${DV}x" \
		$(use_scons ipv6) \
		$(use_scons music sdlmixer) \
		$(use_scons debug) \
		$(use_scons opengl) || die
}

src_install() {
	dodoc {CHANGELOG,INSTALL,README,RELEASE-NOTES}.txt

	insinto "${GAMES_DATADIR}/d${DV}x"
	doins "${DISTDIR}"/d1xrdata.zip
	# None of the following zip files need to be extracted.
	use linguas_de && doins "${DISTDIR}"/d${DV}xr-briefings-ger.zip
	use opl3-musicpack && doins "${DISTDIR}"/d${DV}xr-opl3-music.zip
	use sc55-musicpack && doins "${DISTDIR}"/d${DV}xr-sc55-music.zip

	if use cdinstall ; then
		doins Data/descent.{hog,pig}
		insinto "${GAMES_DATADIR}"/d${DV}x/missions
		doins Data/chaos.{hog,msn}
	fi
	doicon "${WORKDIR}/${PN}.xpm"

	dogamesbin d${DV}x-rebirth
	make_desktop_entry d${DV}x-rebirth "Descent ${DV} Rebirth"
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
}
