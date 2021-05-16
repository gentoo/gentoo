# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop gnome2-utils unpacker

TIMESTAMP="${PV:0:4}-${PV:4:2}-${PV:6:2}"
MY_PN="Grimrock"
DESCRIPTION="Legend of Grimrock: The ultimate dungeon crawling RPG + modding engine"
HOMEPAGE="http://www.grimrock.net/"
SRC_URI="Grimrock-Linux-${TIMESTAMP}.sh"

SLOT="0"
LICENSE="all-rights-reserved"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="fetch bindist splitdebug"

QA_PREBUILT="/opt/${PN}/${MY_PN}.bin"

RDEPEND="media-libs/freeimage
	media-libs/freetype:2
	media-libs/openal
	media-libs/libsdl2[opengl,sound,video]
	media-libs/libvorbis
	sys-libs/zlib[minizip]
	virtual/opengl
	x11-libs/libX11"

DEPEND="app-arch/xz-utils"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to your distfiles directory."
}

src_unpack() {
	myarch=$(usex amd64 x86_64 x86)
	unpack_makeself

	local i
	for i in subarch instarchive_all instarchive_linux_${myarch}; do
		ln -snf "${i}" "${i}.tar.xz" || die
		unpack ./"${i}.tar.xz"
	done
}

src_install() {
	local dir=/opt/${PN}

	insinto "${dir}"
	doins ${PN}.{dat,png}

	exeinto "${dir}"
	newexe ${MY_PN}.bin{.${myarch},}
	dosym "../..${dir}"/${MY_PN}.bin /usr/bin/${PN}

	doicon -s 256 ${PN}.png
	newicon -s 64 ${MY_PN}.png ${PN}.png
	make_desktop_entry ${PN} "Legend of ${MY_PN}"

	dodoc README.linux
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
