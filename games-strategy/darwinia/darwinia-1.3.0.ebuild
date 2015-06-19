# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/darwinia/darwinia-1.3.0.ebuild,v 1.19 2015/06/01 20:51:01 mr_bones_ Exp $

EAPI=5
CDROM_OPTIONAL="yes"
inherit eutils unpacker cdrom games

DESCRIPTION="the hyped indie game of the year. By the Uplink creators"
HOMEPAGE="http://www.darwinia.co.uk/support/linux.html"
SRC_URI="http://www.introversion.co.uk/darwinia/downloads/${PN}-full-${PV}.sh"

LICENSE="Introversion"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
RESTRICT="mirror strip"

RDEPEND="
	~virtual/libstdc++-3.3
	media-libs/libsdl[abi_x86_32(-)]
	media-libs/libvorbis[abi_x86_32(-)]
	virtual/glu[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]"

S=${WORKDIR}

dir=${GAMES_PREFIX_OPT}/${PN}

src_unpack() {
	use cdinstall && cdrom_get_cds gamefiles/main.dat
	unpack_makeself
}

src_install() {
	insinto "${dir}"/lib
	exeinto "${dir}"/lib

	doins lib/{language,patch}.dat
	doexe lib/darwinia.bin.x86 lib/open-www.sh

	exeinto "${dir}"
	doexe bin/Linux/x86/darwinia

	if use cdinstall ; then
		doins "${CDROM_ROOT}"/gamefiles/{main,sounds}.dat
	fi

	dodoc README
	newicon darwinian.png darwinia.png

	games_make_wrapper darwinia ./darwinia "${dir}" "${dir}"
	make_desktop_entry darwinia "Darwinia"
	prepgamesdirs
}

pkg_postinst() {
	if ! use cdinstall; then
		ewarn "To play the game, you need to copy main.dat and sounds.dat"
		ewarn "from gamefiles/ on the game CD to ${dir}/lib/."
	fi
	games_pkg_postinst
}
