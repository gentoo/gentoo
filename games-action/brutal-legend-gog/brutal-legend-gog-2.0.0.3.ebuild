# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHECKREQS_DISK_BUILD="8600M"
inherit check-reqs desktop unpacker xdg

MY_PN="${PN%-gog}"
DESCRIPTION="Rock-themed action-adventure that marries visceral action combat with open-world"
HOMEPAGE="https://www.gog.com/game/brutal_legend"
SRC_URI="gog_brutal_legend_${PV}.sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="bindist fetch splitdebug"

BDEPEND="
	app-arch/unzip
	media-libs/libpng
"

RDEPEND="
	media-libs/glu[abi_x86_32]
	media-libs/libsdl2[abi_x86_32,joystick,opengl,sound,video]
	>=sys-devel/gcc-3.4[cxx]
	>=sys-libs/glibc-2.7[stack-realign(-)]
	sys-libs/zlib[abi_x86_32]
	virtual/opengl[abi_x86_32]
	!${CATEGORY}/${MY_PN}-hb
"

S="${WORKDIR}/data/noarch/game"
DIR="/opt/${MY_PN}"
QA_PREBUILT="${DIR#/}/*"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to your distfiles directory."
}

src_unpack() {
	unpack_zip "${A}"
}

src_prepare() {
	default

	# The distributed icon is broken so fix it. pngfix exits unsuccessfully when
	# it fixes an image, so run it again to check the fixed image.
	pngfix --out="${T}"/Buddha.png Buddha.png ||
		pngfix "${T}"/Buddha.png || die
}

src_install() {
	exeinto "${DIR}"
	doexe Buddha.bin.x86
	dosym ../..${DIR}/Buddha.bin.x86 /usr/bin/${MY_PN}

	insinto "${DIR}"
	doins -r "${T}"/Buddha.png DFCONFIG Data/ Linux/ OGL/ Win/

	exeinto "${DIR}"/lib
	doexe lib/libfmod*.so lib/libsteam_api.so

	make_desktop_entry ${MY_PN} "Brütal Legend" "${EPREFIX}${DIR}"/Buddha.png
}
