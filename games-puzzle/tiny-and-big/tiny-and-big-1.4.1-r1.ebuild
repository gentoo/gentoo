# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop wrapper

DESCRIPTION="Combines elements of adventure, jump&run and physical puzzles"
HOMEPAGE="http://www.tinyandbig.com/"
SRC_URI="tinyandbig_grandpasleftovers-retail-linux-${PV}_1370968537.tar.bz2"
S="${WORKDIR}"/tinyandbig

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="bundled-libs"

RESTRICT="bindist fetch bundled-libs? ( splitdebug )"

MYGAMEDIR=opt/${PN}
QA_PREBUILT="${MYGAMEDIR#/}/bin32/*
	${MYGAMEDIR#/}/bin64/*"

# TODO: unbundle media-libs/cal3d, lib hacked or old version
RDEPEND="
	media-libs/openal
	virtual/opengl
	x11-libs/libX11
	!bundled-libs? (
		media-gfx/nvidia-cg-toolkit
	)
"
BDEPEND="app-arch/bzip2"

pkg_nofetch() {
	einfo "Please buy & download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to your DISTDIR directory."
	einfo
}

src_prepare() {
	default

	if ! use bundled-libs ; then
		rm -v $(usex amd64 "bin64" "bin32")/libCg{,GL}.so || die "unbundling libs failed!"
	fi
}

src_install() {
	local bindir=$(usex amd64 "bin64" "bin32")

	insinto ${MYGAMEDIR}
	doins -r assets ${bindir}

	make_wrapper ${PN} "./${bindir}/tinyandbig" "${MYGAMEDIR}" "${MYGAMEDIR}/${bindir}"
	make_desktop_entry ${PN} "Tiny & Big"
	dodoc readme.txt

	fperms +x ${MYGAMEDIR}/${bindir}/tinyandbig
}
