# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop unpacker xdg

MY_PN="Grimrock"
MY_TIMESTAMP="${PV:0:4}-${PV:4:2}-${PV:6:2}"

DESCRIPTION="Legend of Grimrock: The ultimate dungeon crawling RPG + modding engine"
HOMEPAGE="http://www.grimrock.net/"
SRC_URI="Grimrock-Linux-${MY_TIMESTAMP}.sh"
S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="bindist fetch"

QA_PREBUILT="opt/${PN}/${MY_PN}.bin"

RDEPEND="
	media-libs/freeimage
	media-libs/freetype:2
	media-libs/libsdl2[opengl,sound,video]
	media-libs/libvorbis
	media-libs/openal
	sys-libs/zlib[minizip]
	virtual/opengl
	x11-libs/libX11"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to your distfiles directory."
}

src_unpack() {
	MY_ARCH=$(usex amd64 x86_64 x86)

	unpack_makeself

	local i
	for i in subarch instarchive_all instarchive_linux_${MY_ARCH}; do
		ln -snf ${i} ${i}.tar.xz || die
		unpack ./${i}.tar.xz
	done
}

src_install() {
	local dir=/opt/${PN}

	insinto ${dir}
	doins ${PN}.{dat,png}

	exeinto ${dir}
	newexe ${MY_PN}.bin{.${MY_ARCH},}
	dosym ../..${dir}/${MY_PN}.bin /usr/bin/${PN}

	doicon -s 256 ${PN}.png
	newicon -s 64 ${MY_PN}.png ${PN}.png
	make_desktop_entry ${PN} "Legend of ${MY_PN}"

	dodoc README.linux
}
