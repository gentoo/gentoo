# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# TODO: unbundling sdl-sound breaks the game

EAPI=5

inherit eutils unpacker gnome2-utils games

MY_PN=ToTheMoon
DESCRIPTION="Indie Adventure RPG, two doctors traversing the memories of a dying man to fulfill his last wish"
HOMEPAGE="http://freebirdgames.com/games/to-the-moon"
SRC_URI="${MY_PN}_linux_1389114090.sh"

LICENSE="all-rights-reserved bundled-libs? ( LGPL-2 LGPL-2.1 ZLIB )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="bundled-libs"
RESTRICT="fetch bindist splitdebug"

QA_PREBUILT="${GAMES_PREFIX_OPT}/${PN}/${MY_PN}.bin*"
if [[ ${ARCH} == "amd64" ]] ; then
	QA_PREBUILT="${QA_PREBUILT} ${GAMES_PREFIX_OPT}/${PN}/lib64/*"
else
	QA_PREBUILT="${QA_PREBUILT} ${GAMES_PREFIX_OPT}/${PN}/lib/*"
fi

RDEPEND="
	!bundled-libs? (
		dev-libs/libsigc++:2
		>=media-libs/libsdl2-2.0.1[X,joystick,opengl,sound,threads,video]
		media-libs/openal
		media-libs/sdl2-image[png]
		media-libs/sdl2-ttf
	)
	sys-libs/zlib
	virtual/opengl"

S=${WORKDIR}/data

pkg_nofetch() {
	einfo
	einfo "Please buy & download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo
}

src_unpack() {
	# mojo stuff inside makeself archive, unpack_makeself fails
	local lastline=$(( $(grep -a -h -n -m 1 -F -e "Extra newline, because in very rare cases (OpenSolaris) stub is directly added after script" "${DISTDIR}/${A}" | cut -d':' -f1) + 1 ))
	[[ ${lastline} ]] || die "no last line"
	local offset=$(head -n ${lastline} "${DISTDIR}/${A}" | wc -c)
	[[ ${offset} ]] || die "no offset"
	dd ibs=${offset} skip=1 if="${DISTDIR}/${A}" of="${T}"/moon.zip || die
	unpack_zip "${T}"/moon.zip
}

src_install() {
	local dir=${GAMES_PREFIX_OPT}/${PN}
	local libsuffix=$(usex amd64 "64" "")
	local arch=$(usex amd64 "x86_64" "x86")

	insinto "${dir}"
	doins -r noarch/{Audio,Data,Fonts,Graphics,Game.ini,mkxp.conf,ToTheMoon.png}

	exeinto "${dir}"
	doexe ${arch}/${MY_PN}.bin.${arch}

	exeinto "${dir}/lib${libsuffix}"
	if use bundled-libs ; then
		doexe ${arch}/lib${libsuffix}/*
	else
		doexe ${arch}/lib${libsuffix}/libSDL_sound-1.0.so.1
	fi

	games_make_wrapper ${PN} "./${MY_PN}.bin.${arch}" "${dir}" "${dir}/lib${libsuffix}"
	make_desktop_entry ${PN} "To the Moon"
	newicon -s 32 noarch/${MY_PN}.png ${PN}.png

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
