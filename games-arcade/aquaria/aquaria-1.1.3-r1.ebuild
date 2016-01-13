# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit unpacker eutils games

DESCRIPTION="A 2D scroller set in a massive ocean world"
HOMEPAGE="http://www.bit-blot.com/aquaria/"
SRC_URI="aquaria-lnx-humble-bundle.mojo.run"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="strip fetch bindist"

DEPEND="app-arch/unzip"
RDEPEND="
	>=media-libs/libsdl-1.2.15-r4[abi_x86_32(-)]
	>=media-libs/openal-1.15.1[abi_x86_32(-)]"

S=${WORKDIR}/data

dir=${GAMES_PREFIX_OPT}/${PN}
QA_PREBUILT="${dir#/}/aquaria"

pkg_nofetch() {
	echo
	elog "Download ${SRC_URI} from ${HOMEPAGE} and place it in ${DISTDIR}"
	echo
}

src_unpack() {
	unpack_zip ${A}
}

src_install() {
	insinto "${dir}"
	exeinto "${dir}"

	doins -r *.xml */
	doexe "${PN}"
	doicon "${PN}.png"

	dodoc README-linux.txt
	mv "${ED}/${dir}"/docs "${ED}/usr/share/doc/${PF}/html" || die
	dosym /usr/share/doc/${PF}/html "${dir}"/docs

	games_make_wrapper "${PN}" "./${PN}" "${dir}"
	make_desktop_entry "${PN}" "Aquaria"

	prepgamesdirs
}
