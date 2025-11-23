# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHECKREQS_DISK_BUILD="5237M"
inherit check-reqs desktop unpacker wrapper xdg

MY_PN="Psychonauts"

DESCRIPTION="A mind-bending platforming adventure from Double Fine Productions"
HOMEPAGE="https://www.doublefine.com/games/psychonauts"
SRC_URI="${MY_PN,,}-linux-${PV:4:2}${PV:6:2}${PV:0:4}-bin"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="bindist fetch splitdebug"

BDEPEND="
	app-arch/unzip
	media-libs/libpng
"

RDEPEND="
	media-libs/libsdl[abi_x86_32,opengl,video]
	media-libs/openal[abi_x86_32]
	>=sys-devel/gcc-3.4[cxx]
	sys-libs/glibc
	!${CATEGORY}/${MY_PN,,}
	!${CATEGORY}/${MY_PN,,}-gog
"

S="${WORKDIR}/data"
DIR="/opt/${MY_PN,,}"
QA_PREBUILT="${DIR#/}/*"

pkg_nofetch() {
	elog "Please buy and download ${SRC_URI} from:"
	elog "  https://www.humblebundle.com/store/${MY_PN,,}"
	elog "and move it to your distfiles directory."
}

src_unpack() {
	unpack_zip ${A}
}

src_prepare() {
	default

	# The distributed icon is broken so fix it. pngfix exits unsuccessfully when
	# it fixes an image, so run it again to check the fixed image.
	pngfix --out="${T}"/${MY_PN,,}.png ${MY_PN,,}.png ||
			pngfix "${T}"/${MY_PN,,}.png || die
}

src_install() {
	exeinto "${DIR}"
	doexe ${MY_PN}
	make_wrapper ${MY_PN,,} "${DIR}"/${MY_PN}

	insinto "${DIR}"
	doins -r icon.bmp WorkResource/ *.pkg

	doicon -s 512 "${T}"/${MY_PN,,}.png
	make_desktop_entry ${MY_PN,,} ${MY_PN} ${MY_PN,,}

	dodoc \
		"Psychonauts Manual Win.pdf" \
		README-linux.txt
}
