# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils unpacker multilib games

DESCRIPTION="You play the Postal Dude: Postal 2 is only as violent as you are"
HOMEPAGE="http://icculus.org/news/news.php?id=4419"
SRC_URI="http://treefort.icculus.org/postal2/Postal2STP-FreeMP-linux.tar.bz2
	http://0day.icculus.org/postal2/Postal2STP-FreeMP-linux.tar.bz2
	http://cyberstalker.dk/sponsored-by-dkchan.org/Postal2STP-FreeMP-linux.tar.bz2"

LICENSE="postal2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror strip"

RDEPEND="sys-libs/glibc
	sys-libs/libstdc++-v3:5
	amd64? ( sys-libs/glibc[multilib] sys-libs/libstdc++-v3:5[multilib] )
	>=media-libs/libsdl-1.2.15-r4[X,opengl,abi_x86_32(-)]
	>=media-libs/openal-1.15.1[abi_x86_32(-)]"
DEPEND=""

QA_PREBUILT="${GAMES_PREFIX_OPT:1}/${PN}/System/*"

S=${WORKDIR}/Postal2STP-FreeMP-linux

src_install() {
	has_multilib_profile && ABI=x86

	dir=${GAMES_PREFIX_OPT}/${PN}

	insinto "${dir}"
	doins -r *
	fperms +x "${dir}"/System/postal2-bin

	rm "${ED}/${dir}"/System/{openal.so,libSDL-1.2.so.0,libstdc++.so.5,libgcc_s.so.1} || die
	dosym /usr/$(get_libdir)/libopenal.so "${dir}"/System/openal.so
	dosym /usr/$(get_libdir)/libSDL-1.2.so.0 "${dir}"/System/libSDL-1.2.so.0

	games_make_wrapper ${PN} ./postal2-bin "${dir}"/System .
	newicon postal2.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Postal 2: Share the Pain (Demo)"

	prepgamesdirs
}
