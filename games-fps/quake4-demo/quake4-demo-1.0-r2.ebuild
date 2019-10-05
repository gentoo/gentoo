# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils unpacker games

MY_P="quake4-linux-${PV}-demo"
DESCRIPTION="Sequel to Quake 2, an Id 3D first-person shooter"
HOMEPAGE="http://www.quake4game.com/"
SRC_URI="mirror://idsoftware/quake4/demo/${MY_P}.x86.run
	http://www.3ddownloads.com/Action/Quake%204/Demos/${MY_P}.x86.run
	http://filebase.gmpf.de/quake4/${MY_P}.x86.run
	http://www.holarse.de/mirror/${MY_P}.x86.run
	http://sonic-lux.net/data/mirror/quake4/${MY_P}.x86.run"

LICENSE="QUAKE4"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="dedicated"
RESTRICT="bindist mirror strip"

RDEPEND="sys-libs/glibc
	sys-libs/libstdc++-v3:5
	amd64? ( sys-libs/glibc[multilib] sys-libs/libstdc++-v3:5[multilib] )
	dedicated? ( app-misc/screen )
	!dedicated? (
		|| (
			virtual/opengl[abi_x86_32(-)]
			x11-drivers/nvidia-drivers
		)
		>=x11-libs/libX11-1.6.2[abi_x86_32(-)]
		>=x11-libs/libXext-1.3.2[abi_x86_32(-)]
		>=media-libs/libsdl-1.2.15-r4[X,opengl,sound,abi_x86_32(-)]
	)"

S=${WORKDIR}
dir=${GAMES_PREFIX_OPT}/${PN}
Ddir=${D}/${dir}

QA_PREBUILT="${dir:1}/quake4.x86
	${dir:1}/q4ded.x86"

src_install() {
	insinto "${dir}"
	doins License.txt q4icon.bmp version.info
	dodoc README

	exeinto "${dir}"
	doexe openurl.sh bin/Linux/x86/q4ded.x86
	games_make_wrapper ${PN}-ded ./q4ded.x86 "${dir}" "${dir}"

	insinto "${dir}"/q4base
	doins q4base/*

	if ! use dedicated ; then
		doexe bin/Linux/x86/quake4.x86
		games_make_wrapper ${PN} ./quake4.x86 "${dir}" "${dir}"
		newicon q4icon.bmp ${PN}.bmp || die
		make_desktop_entry ${PN} "Quake IV (Demo)" /usr/share/applications/${PN}.bmp
	fi

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	if ! use dedicated; then
		elog "To play the game run:"
		elog " quake4-demo"
		echo
	fi
	elog "To start the gameserver, run:"
	elog " quake4-demo-ded"
}
