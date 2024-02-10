# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHECKREQS_DISK_BUILD="1200M"
inherit desktop check-reqs xdg

DESCRIPTION="Narrative-driven, single-player adventure like mom used to make"
HOMEPAGE="https://mattmakesgames.itch.io/celeste"
SRC_URI="${PN}-linux.zip"
S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="bindist fetch splitdebug"

DIR="/opt/${PN}"
QA_PREBUILT="${DIR#/}/*"

RDEPEND="media-libs/libsdl2[joystick,opengl,sound,video]"
BDEPEND="app-arch/unzip"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to your distfiles directory."
}

src_prepare() {
	default
	rm -v \
		lib*/libSDL2-2.0.so.0 \
		lib*/libSDL2_image-2.0.so.0 \
		lib*/libpng15.so.15 \
		|| die
}

src_install() {
	local \
		arch=$(usex amd64 x86_64 x86) \
		libdir=lib$(usex amd64 64 "")

	insinto "${DIR}"
	doins -r *.dll* Celeste.exe* Celeste*.pdb Content/ mono*

	exeinto "${DIR}"
	doexe Celeste.bin.${arch}

	exeinto "${DIR}"/${libdir}
	doexe ${libdir}/*.so*

	newicon -s 512 Celeste.png ${PN}.png
	dosym "../..${DIR}/Celeste.bin.${arch}" /usr/bin/${PN}
	make_desktop_entry ${PN} Celeste
}
