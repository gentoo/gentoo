# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop wrapper

MY_PN="Deponia Doomsday"
DESCRIPTION="The fourth and final instalment of the Deponia point-and-click adventures"
HOMEPAGE="https://www.daedalic.com/deponia"
SRC_URI="Deponia4_${PV}_DEB_Full_Multi_Daedalic_ESD.tar"
LICENSE="all-rights-reserved BSD LGPL-2.1 MIT OFL-1.1"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="bonus"
RESTRICT="bindist fetch splitdebug strip"

# Bundles libopenal.so but 1.20.0 and later are not compatible because
# the game uses the SelectResampler function, which was inlined.

RDEPEND="
	media-libs/libpng-compat:1.2
	media-libs/libsdl2[opengl,video]
	sys-libs/zlib
	virtual/opengl
"

S="${WORKDIR}/${MY_PN}"

DIR="/opt/${PN}"
QA_PREBUILT="${DIR}/*"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  https://www.humblebundle.com/store/${PN}"
	einfo "and move it to your distfiles directory."
}

src_prepare() {
	default
	rm libs64/libz.so.1 || die
}

src_install() {
	exeinto "${DIR}"
	doexe Deponia4

	make_wrapper \
		${PN} \
		"env SDL_DYNAMIC_API=\"${EPREFIX}/usr/$(get_libdir)/libSDL2-2.0.so.0\" ./Deponia4" \
		"${DIR}" \
		"${DIR}/lib"

	insinto "${DIR}"
	doins -r \
		  config.ini \
		  data.vis \
		  version.txt \
		  characters/ \
		  lua/ \
		  scenes/ \
		  videos/

	use bonus && doins -r "bonus content/"

	exeinto "${DIR}"/lib
	doexe libs64/*

	make_desktop_entry ${PN} "${MY_PN}" applications-games
	dodoc changes.txt documents/licenses/readme.txt
}
