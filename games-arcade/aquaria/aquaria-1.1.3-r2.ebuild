# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop unpacker wrapper

DESCRIPTION="A 2D scroller set in a massive ocean world"
HOMEPAGE="http://www.bit-blot.com/aquaria/"
SRC_URI="aquaria-lnx-humble-bundle.mojo.run"
S="${WORKDIR}"/data

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="strip fetch bindist"

RDEPEND="
	>=media-libs/libsdl-1.2.15-r4[abi_x86_32(-)]
	>=media-libs/openal-1.15.1[abi_x86_32(-)]"
BDEPEND="app-arch/unzip"

dir=opt/${PN}
QA_PREBUILT="${dir#/}/aquaria"

pkg_nofetch() {
	echo
	elog "Download ${SRC_URI} from ${HOMEPAGE} and place it into"
	elog "your DISTDIR directory."
	echo
}

src_unpack() {
	unpack_zip ${A}
}

src_install() {
	insinto ${dir}
	exeinto ${dir}

	doins -r *.xml */
	doexe ${PN}
	doicon ${PN}.png

	dodoc README-linux.txt
	mv "${ED}/${dir}"/docs "${ED}/usr/share/doc/${PF}/html" || die
	dosym  ../../../usr/share/doc/${PF}/html ${dir}/docs

	make_wrapper "${PN}" "./${PN}" "${dir}"
	make_desktop_entry "${PN}" "Aquaria"
}
