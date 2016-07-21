# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

MY_P="linuxphobia-${PV}"
DESCRIPTION="Just a moment ago, you were safe inside your ship, behind five inch armour"
HOMEPAGE="http://www.lynxlabs.com/games/linuxphobia/index.html"
SRC_URI="http://www.lynxlabs.com/games/linuxphobia/${MY_P}-i386.tar.bz2"

LICENSE="freedist"		#505612
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="sys-libs/lib-compat
	media-libs/sdl-mixer[abi_x86_32(-)]
	media-libs/libsdl[abi_x86_32(-)]"

S=${WORKDIR}/${MY_P}

QA_PRESTRIPPED="opt/phobiaii/linuxphobia"
QA_FLAGS_IGNORED="opt/phobiaii/linuxphobia"

src_install() {
	local dir=${GAMES_PREFIX_OPT}/${PN}
	games_make_wrapper phobiaII ./linuxphobia "${dir}"
	newicon phobia2.ico ${PN}.ico
	make_desktop_entry phobiaII "Phobia II" /usr/share/pixmaps/${PN}.ico
	insinto "${dir}"
	doins -r *
	rm -rf "${D}/${dir}"/{*.desktop,*.sh,/pics/.xvpics}
	fperms 750 "${dir}"/linuxphobia
	prepgamesdirs
}
