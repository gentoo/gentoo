# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker wrapper xdg

MY_PN="ShovelKnight"
DESCRIPTION="Sweeping classic action adventure with an 8-bit retro aesthetic"
HOMEPAGE="https://yachtclubgames.com/games/shovel-knight-treasure-trove/"
SRC_URI="${PN//-/_}_treasure_trove_4_1b_arby_s_46298.sh"
S="${WORKDIR}/data/noarch/game"

LICENSE="Yacht-Club-Games-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="+joystick"
RESTRICT="bindist fetch splitdebug"

# I packaged Box2D in the hope of unbundling it but it turns out this
# game uses a custom version. -- Chewi :(

RDEPEND="
	media-libs/glew:1.10
	virtual/opengl
	!x86? ( media-libs/libsdl2[joystick?,opengl,sound,video] )
	x86? ( !joystick? ( media-libs/libsdl2[opengl,sound,video] ) )
"

BDEPEND="
	dev-util/patchelf
"

DIR="/opt/${PN}"
QA_PREBUILT="${DIR#/}/*"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  https://www.gog.com/game/${PN//-/_}"
	einfo "and move it to your distfiles directory."
}

src_unpack() {
	unpack_zip ${A}
}

src_install() {
	local BITS=$(usex amd64 64 32) LIB=

	exeinto "${DIR}"
	doexe ${BITS}/${MY_PN}
	make_wrapper ${MY_PN} ./${MY_PN} "${DIR}"

	exeinto "${DIR}"/lib
	doexe ${BITS}/lib/lib{Box2D.so.*,fmod*-*.so}

	for LIB in ${BITS}/lib/libfmod*-*.so; do
		LIB=${LIB##*/}

		# The FMOD libraries are duplicated rather than symlinked, which is
		# silly, so create our own symlinks. Both sets of names are needed.
		dosym "${LIB}" "${DIR}/lib/${LIB%-*}.so"

		# The SONAMEs are also unset, which upsets our QA check, so fix.
		patchelf --set-soname "${LIB%-*}.so" "${ED}${DIR}/lib/${LIB}" || die
	done

	if use joystick; then
		local SDL=libSDL2-2.0.so.0
		local SDLj=libSDL2-joystick.so

		if use x86; then
			# Under x86, using our own SDL2 causes the game to crash when a
			# controller is connected, even after applying the workaround below.
			# It is seemingly caused by a change to the SDL_GetJoystickGUIDInfo
			# signature. We must therefore use the bundled SDL2.
			doexe ${BITS}/lib/${SDL}
		else
			# The game uses internal SDL2 joystick functions. These functions
			# have since been hidden and some have been removed. Using our own
			# SDL2 therefore causes the game to crash when a controller is
			# connected. We still want to use our own SDL2 for things like
			# Wayland, but we can work around this by loading both, using the
			# bundled one as a fallback.
			newexe ${BITS}/lib/${SDL} ${SDLj}

			# The bundled SDL2 SONAME has to be set to something different.
			patchelf --set-soname ${SDLj} "${ED}${DIR}"/lib/${SDLj} || die

			# We need to add the new SONAME as a NEEDED entry, but the order is
			# important, so we also need to remove the existing NEEDED entry
			# first and add it back again afterwards.
			patchelf \
				--remove-needed ${SDL} \
				--add-needed ${SDLj} \
				--add-needed ${SDL} \
				"${ED}${DIR}"/${MY_PN} || die
		fi
	fi

	# The RUNPATHs are not entirely correct so fix up.
	patchelf --set-rpath '$ORIGIN/lib' "${ED}${DIR}"/${MY_PN} || die
	patchelf --set-rpath '$ORIGIN' "${ED}${DIR}"/lib/libfmodevent*.so || die

	insinto "${DIR}"
	doins -r data/

	newicon -s 256 ../support/icon.png ${PN}.png
	make_desktop_entry ${MY_PN} "Shovel Knight"
}
