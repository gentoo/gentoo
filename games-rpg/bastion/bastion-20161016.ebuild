# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop check-reqs unpacker wrapper xdg

TIMESTAMP=${PV:4:2}${PV:6:2}${PV:0:4}
DESCRIPTION="An original action role-playing game set in a lush imaginative world"
HOMEPAGE="https://supergiantgames.com/games/bastion/"
SRC_URI="bastion-${TIMESTAMP}-bin"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="bindist fetch splitdebug"

DIR="/opt/${PN}"
QA_PREBUILT="${DIR#/}/*"

# Being a Mono-based game, it is tricky to determine the precise
# dependencies. These were found by trial and error.
RDEPEND="
	media-libs/libsdl2[joystick,opengl,sound,video]
	media-libs/libvorbis
"
BDEPEND="
	app-arch/unzip
"

CHECKREQS_DISK_BUILD="2400M"
S="${WORKDIR}/data"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  https://www.humblebundle.com/store/${PN}"
	einfo "and move it to your distfiles directory."
}

src_unpack() {
	unpack_zip ${A}
}

src_prepare() {
	default
	rm -v lib*/libSDL2-2.0.so.0 || die
}

src_install() {
	local \
		arch=$(usex amd64 x86_64 x86) \
		libdir=lib$(usex amd64 64 "")

	insinto "${DIR}"
	doins -r *.dll* Bastion.exe steam_appid.txt Content/ mono/

	exeinto "${DIR}"
	doexe Bastion.bin.${arch}

	exeinto "${DIR}"/${libdir}
	doexe ${libdir}/*.so*

	dodoc Linux.README

	make_wrapper ${PN} "env -u TERM \"${EPREFIX}${DIR}/Bastion.bin.${arch}\""
	make_desktop_entry ${PN} Bastion applications-games
}
