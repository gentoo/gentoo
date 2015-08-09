# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils gnome2-utils check-reqs unpacker games

TIMESTAMP=${PV:0:4}-${PV:4:2}-${PV:6:2}
DESCRIPTION="An original action role-playing game set in a lush imaginative world"
HOMEPAGE="http://supergiantgames.com/?page_id=242"
SRC_URI="Bastion-HIB-${TIMESTAMP}.sh"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
RESTRICT="bindist fetch splitdebug"

MYGAMEDIR=${GAMES_PREFIX_OPT}/${PN}
QA_PREBUILT="${MYGAMEDIR#/}/Bastion.bin*
	${MYGAMEDIR#/}/lib/*
	${MYGAMEDIR#/}/lib64/*"

# mono shit: vague dependencies
RDEPEND="
	virtual/opengl
	media-libs/freealut
	media-libs/openal
	media-libs/sdl-gfx
	media-libs/sdl-image
	media-libs/sdl-mixer
	media-libs/sdl-net
	media-libs/sdl-ttf
	media-libs/smpeg
	x11-libs/libX11
	x11-libs/libXft"

CHECKREQS_DISK_BUILD="2400M"

pkg_nofetch() {
	einfo "Please buy & download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to ${DISTDIR}"
}

src_unpack() {
	myarch=$(usex amd64 "x86_64" "x86")

	unpack_makeself

	mv instarchive_all{,.tar.lzma} || die
	mv instarchive_linux_${myarch}{,.tar.lzma} || die

	mkdir ${P} || die
	cd ${P} || die

	unpack ./../instarchive_{all,linux_${myarch}}.tar.lzma
}

src_install() {
	insinto "${MYGAMEDIR}"
	doins -r *

	newicon -s 256 Bastion.png ${PN}.png
	make_desktop_entry ${PN}
	games_make_wrapper ${PN} "./Bastion.bin.${myarch}" "${MYGAMEDIR}" "${MYGAMEDIR}/$(get_libdir)"

	fperms +x "${MYGAMEDIR}"/Bastion.bin.${myarch}
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst

	elog "If you are using opensource drivers you should consider installing:"
	elog "    media-libs/libtxc_dxtn"

	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
