# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# TODO: fmod support broken (deng_fmod)

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit python-r1 eutils qmake-utils games

DESCRIPTION="A modern gaming engine for Doom, Heretic, and Hexen"
HOMEPAGE="http://www.dengine.net/"
SRC_URI="mirror://sourceforge/deng/Doomsday%20Engine/${PV}/${PN}-stable-${PV}.tar.gz"

LICENSE="GPL-3+ LGPL-3+"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="dedicated fluidsynth openal snowberry +doom demo freedoom heretic hexen resources tools"
# we need python at build time, so
# snowberry? ( ${PYTHON_REQUIRED_USE} )
# could break the build
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	demo? ( doom ) freedoom? ( doom ) resources? ( doom )"

DEPEND="
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtgui:5
	dev-qt/qtcore:5
	net-misc/curl
	sys-libs/zlib
	media-libs/assimp
	!dedicated? (
		media-libs/libsdl2[joystick,sound]
		media-libs/sdl2-mixer
		media-libs/libpng:0
		virtual/opengl
		virtual/glu
		x11-libs/libX11
		x11-libs/libXrandr
		x11-libs/libXxf86vm
	)
	fluidsynth? ( media-sound/fluidsynth )
	openal? ( media-libs/openal )
	tools? ( sys-libs/ncurses:0 )"
RDEPEND="${DEPEND}
	!dedicated? (
		snowberry? (
			${PYTHON_DEPS}
			dev-lang/python-exec:2[${PYTHON_USEDEP}]
			dev-python/wxpython[${PYTHON_USEDEP}]
		)
	)"
DEPEND="${DEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig"
PDEPEND="
	!dedicated? (
		demo? ( games-fps/doom-data )
		freedoom? ( games-fps/freedoom )
		resources? ( games-fps/doomsday-resources )
	)"

S=${WORKDIR}/${PN}-stable-${PV}/${PN}

pkg_setup() {
	games_pkg_setup
	python_setup
}

src_prepare() {
	sed -i \
		-e '/readme.path/s#$$PREFIX#/usr#' \
		client/client.pro server/server.pro || die

	sed -i \
		-e "/DENG_BASE_DIR =/s:\$\$PREFIX/share:${GAMES_DATADIR}:" \
		config_unix.pri || die

	{
		echo "CONFIG += nostrip"
		echo "PREFIX=${GAMES_PREFIX}"

		if use dedicated ; then
			echo "CONFIG += deng_noclient"
			echo "CONFIG += deng_nosnowberry"
		else
			echo "CONFIG += deng_$(usex snowberry '' no)snowberry"
		fi

		use fluidsynth && echo "CONFIG += deng_fluidsynth"

		use tools || echo "CONFIG += deng_notools"

		use openal && echo "CONFIG += deng_openal"
		true

	} > config_user.pri || die
}

#Usage: doom_make_wrapper <name> <game> <icon> <desktop entry title> [args]
doom_make_wrapper() {
	local name=$1 game=$2 icon=$3 de_title=$4
	shift 4
	games_make_wrapper $name "doomsday -game ${game} $@"
	make_desktop_entry $name "${de_title}" ${icon}
}

src_configure() {
	eqmake5 doomsday.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	dodoc "${S}"/../README.md

	mv "${D}/${GAMES_DATADIR}"/{${PN}/data/jdoom,doom-data} || die
	dosym "${GAMES_DATADIR}"/doom-data "${GAMES_DATADIR}"/${PN}/data/jdoom

	if use !dedicated ; then
		if use snowberry ; then
			python_replicate_script "${D}"/"${GAMES_BINDIR}"/launch-doomsday

			installmodules() {
				# relocate snowberry module directory recursively into site-packages
				python_domodule "${D}/${GAMES_DATADIR}"/${PN}/snowberry
				# hack around improper path handling
				sed -i \
					-e "s:os.chdir.*$:os.chdir('$(python_get_sitedir)/snowberry'):" \
					"${D%/}$(python_get_scriptdir)"/launch-doomsday || die
			}
			python_foreach_impl installmodules
			# remove old module dir
			rm -r "${D}/${GAMES_DATADIR}"/${PN}/snowberry || die

			make_desktop_entry launch-doomsday "Snowberry DoomsDay" snowberry
			doicon ../snowberry/graphics/snowberry.png
		fi

		if use doom; then
			local res_arg

			if use resources; then
				res_arg="-def \"${GAMES_DATADIR}\"/${PN}/defs/jdoom/jDRP.ded"
			fi

			doicon ../snowberry/graphics/orb-doom.png
			doom_make_wrapper jdoom doom1 orb-doom "DoomsDay Engine: Doom 1" "${res_arg}"
			elog "Created jdoom launcher. To play Doom place your doom.wad to"
			elog "\"${GAMES_DATADIR}\"/doom-data"
			elog

			if use demo; then
				doom_make_wrapper jdoom-demo doom1-share orb-doom "DoomsDay Engine: Doom 1 Demo" \
					"-iwad \"${GAMES_DATADIR}\"/doom-data/doom1.wad ${res_arg}"
			fi
			if use freedoom; then
				doom_make_wrapper jdoom-freedoom doom1-share orb-doom "DoomsDay Engine: FreeDoom" \
					"-iwad \"${GAMES_DATADIR}\"/doom-data/freedoom/doom1.wad"
			fi
		fi
		if use hexen; then
			doicon ../snowberry/graphics/orb-hexen.png
			doom_make_wrapper jhexen hexen orb-hexen "DoomsDay Engine: Hexen"

			elog "Created jhexen launcher. To play Hexen place your hexen.wad to"
			elog "\"${GAMES_DATADIR}\"/${PN}/data/jhexen"
			elog
		fi
		if use heretic; then
			doicon ../snowberry/graphics/orb-heretic.png
			doom_make_wrapper jheretic heretic orb-heretic "DoomsDay Engine: Heretic"

			elog "Created jheretic launcher. To play Heretic place your heretic.wad to"
			elog "\"${GAMES_DATADIR}\"/${PN}/data/jheretic"
			elog
		fi
	fi

	prepgamesdirs
}
