# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils

MY_P="linuxphobia-${PV}"
DESCRIPTION="Just a moment ago, you were safe inside your ship, behind five inch armour"
HOMEPAGE="http://www.lynxlabs.com/games/linuxphobia/index.html"
SRC_URI="http://www.lynxlabs.com/games/linuxphobia/${MY_P}-i386.tar.bz2"

LICENSE="freedist"		#505612
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/libsdl[abi_x86_32(-)]
	media-libs/sdl-mixer[abi_x86_32(-)]
	sys-libs/lib-compat"

S=${WORKDIR}/${MY_P}

QA_PRESTRIPPED="opt/phobiaii/linuxphobia"
QA_FLAGS_IGNORED="opt/phobiaii/linuxphobia"

src_install() {
	local dir=/opt/${PN}
	make_wrapper phobiaII ./linuxphobia "${dir}"
	newicon phobia2.ico ${PN}.ico
	make_desktop_entry phobiaII "Phobia II" /usr/share/pixmaps/${PN}.ico
	insinto "${dir}"
	doins -r *
	rm -rf "${D}/${dir}"/{*.desktop,*.sh,/pics/.xvpics}
	fperms 775 "${dir}"/linuxphobia
}
