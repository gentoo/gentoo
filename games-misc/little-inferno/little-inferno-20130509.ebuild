# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils gnome2-utils unpacker games

DESCRIPTION="Throw your toys into your fire, and play with them as they burn"
HOMEPAGE="http://tomorrowcorporation.com/"
SRC_URI="LittleInferno-${PV}.sh"

LICENSE="Gameplay-Group-EULA"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="bundled-libs"
RESTRICT="bindist fetch bundled-libs? ( splitdebug )"

MYGAMEDIR=${GAMES_PREFIX_OPT}/${PN}
QA_PREBUILT="${MYGAMEDIR#/}/LittleInferno.bin.x86
	${MYGAMEDIR#/}/lib/*"

RDEPEND="
	>=net-misc/curl-7.37.0-r1[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]
	!bundled-libs? (
		>=media-libs/libogg-1.3.1[abi_x86_32(-)]
		>=media-libs/libvorbis-1.3.3-r1[abi_x86_32(-)]
		>=media-libs/openal-1.15.1-r1[abi_x86_32(-)] )"
DEPEND="app-arch/xz-utils"

src_unpack() {
	unpack_makeself ${A}

	mkdir ${P} || die
	cd ${P} || die

	local i
	for i in instarchive_{,linux_}all ; do
		mv ../"${i}" ../"${i}".tar.xz || die
		unpack ./../"${i}".tar.xz
	done
}

src_prepare() {
	if use !bundled-libs ; then
		rm -rv lib || die
	fi
}

src_install() {
	insinto "${MYGAMEDIR}"
	doins -r *

	doicon -s 128 LittleInferno.png
	make_desktop_entry ${PN} "Little Inferno" LittleInferno
	games_make_wrapper ${PN} "./LittleInferno.bin.x86" "${MYGAMEDIR}" "${MYGAMEDIR}/lib"

	fperms +x "${MYGAMEDIR}"/LittleInferno.bin.x86

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
