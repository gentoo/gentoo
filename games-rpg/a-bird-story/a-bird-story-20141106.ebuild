# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils unpacker multilib gnome2-utils games
MY_PN=ABirdStory
DESCRIPTION="Indie adventure short of a boy's memories, dream, and imagination"
HOMEPAGE="http://freebirdgames.com/games/a-bird-story/"
SRC_URI="${MY_PN}-${PV:0:4}-${PV:4:2}-${PV:6:2}.sh"

# missing: SIL, Xiph
# physfs ZLIB
# sdl-sound LGPL-2.1
LICENSE="all-rights-reserved BSD OFL-1.1 LGPL-2.1 ZLIB bundled-libs? ( FTL GPL-2 MIT ( || ( Ruby-BSD BSD-2 ) ) )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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
		dev-games/physfs
		dev-lang/ruby:2.1
		dev-libs/libsigc++:2
		>=media-libs/libsdl2-2.0.1[X,joystick,opengl,sound,threads,video]
		media-libs/libvorbis
		media-libs/openal
		media-libs/sdl2-image[png]
		media-libs/sdl2-ttf
		sys-libs/zlib
		x11-libs/pixman
	)
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
	dd ibs=${offset} skip=1 if="${DISTDIR}/${A}" of="${T}"/bird.zip || die
	unpack_zip "${T}"/bird.zip
}

src_install() {
	local dir=${GAMES_PREFIX_OPT}/${PN}
	local arch=$(usex amd64 "x86_64" "x86")

	insinto "${dir}"
	doins -r noarch/*

	exeinto "${dir}"
	doexe ${arch}/${MY_PN}.$(usex amd64 "amd64" "x86")

	exeinto "${dir}/$(get_libdir)"
	if use bundled-libs ; then
		doexe ${arch}/$(get_libdir)/*
	else
		doexe ${arch}/$(get_libdir)/{libsteam_api.so,libphysfs.so.1,libSDL_sound-1.0.so.1}
	fi

	games_make_wrapper ${PN} \
		"./${MY_PN}.$(usex amd64 "amd64" "x86")" \
		"${dir}" "${dir}/$(get_libdir)"
	make_desktop_entry ${PN} "A bird story"
	newicon -s 48 noarch/icon.png ${PN}.png

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
