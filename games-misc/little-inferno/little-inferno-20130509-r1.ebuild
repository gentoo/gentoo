# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop unpacker wrapper

DESCRIPTION="Throw your toys into your fire, and play with them as they burn"
HOMEPAGE="https://tomorrowcorporation.com/littleinferno"
SRC_URI="LittleInferno-${PV}.sh"
S="${WORKDIR}"

LICENSE="Gameplay-Group-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="bindist fetch"

QA_PREBUILT="
	opt/${PN}/LittleInferno.bin.x86
	opt/${PN}/lib/libogg.so.0
	opt/${PN}/lib/libvorbis.so.0"

RDEPEND="
	media-libs/openal[abi_x86_32(-)]
	net-misc/curl[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]"

pkg_nofetch() {
	einfo "Please buy and download '${A}' from:"
	einfo "  ${HOMEPAGE}"
	einfo "and place it in your distfiles directory."
}

src_unpack() {
	unpack_makeself ${A}
	mv instarchive_all{,.tar.xz} || die
	mv instarchive_linux_all{,.tar.xz} || die
	unpack ./instarchive_{,linux_}all.tar.xz
}

src_install() {
	exeinto /opt/${PN}
	doexe LittleInferno.bin.x86

	insinto /opt/${PN}
	doins -r {debug,embed,frontend,resource}.pak shaders

	# game currently segfaults without bundled libvorbis
	exeinto /opt/${PN}/lib
	doexe lib/lib{ogg,vorbis}.so.0

	make_wrapper ${PN} ./LittleInferno.bin.x86 /opt/${PN}

	newicon LittleInferno.png ${PN}.png
	make_desktop_entry ${PN} "Little Inferno"
}
