# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop wrapper

MY_PN="Deponia - The Complete Journey"
DESCRIPTION="The Complete Journey: The first three Deponia point-and-click adventures"
HOMEPAGE="https://www.daedalic.com/deponia"
SRC_URI="DeponiaTCJ_${PV}_Full_DEB_DE_EN_FR_IT_RU_PL_Daedalic_ESD.tar.gz"
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist fetch splitdebug strip"

RDEPEND="
	media-libs/libsdl2[opengl,video]
	media-libs/openal
	virtual/opengl
"

S="${WORKDIR}/${MY_PN}"

DIR="/opt/${PN}"
QA_PREBUILT="${DIR}/*"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  https://www.humblebundle.com/store/deponia-the-complete-journey"
	einfo "and move it to your distfiles directory."
}

src_prepare() {
	default
	rm libs64/libz.so.1 || die
}

src_install() {
	exeinto "${DIR}"
	doexe deponia_tcj

	make_wrapper \
		${PN} \
		"env SDL_DYNAMIC_API=\"${EPREFIX}/usr/$(get_libdir)/libSDL2-2.0.so.0\" ./deponia_tcj" \
		"${DIR}" \
		"${DIR}/lib"

	insinto "${DIR}"
	doins -r \
		  config.ini \
		  data{,1,2,3}.vis \
		  deponia{1,2,3}/ \
		  lua/ \
		  version.txt

	exeinto "${DIR}"/lib
	doexe libs64/*

	make_desktop_entry ${PN} "${MY_PN}" applications-games
	dodoc readme.txt
}
