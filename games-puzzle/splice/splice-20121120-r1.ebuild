# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop wrapper

DESCRIPTION="An experimental and artistic puzzler set in a microbial world"
HOMEPAGE="http://www.cipherprime.com/games/splice/"
SRC_URI="splice-linux-1353389454.tar.gz"
S="${WORKDIR}"/Linux

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

RESTRICT="bindist fetch splitdebug"

MYGAMEDIR=opt/${PN}
QA_PREBUILT="
	${MYGAMEDIR#/}/Splice*
	${MYGAMEDIR#/}/Splice_Data/Mono/*
"

# TODO: unbundle mono? (seems hardcoded)
#       icon
RDEPEND="
	virtual/glu
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXext"

pkg_nofetch() {
	einfo "Please buy & download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to your DISTDIR directory."
}

src_prepare() {
	default

	einfo "Removing ${ARCH} unrelated files..."
	rm -v Splice.x86$(usex amd64 "" "_64") || die
	rm -rv Splice_Data/Mono/x86$(usex amd64 "" "_64") || die

	rm README~ || die
	mv README "${T}"/ || die
}

src_install() {
	dodoc "${T}"/README

	insinto ${MYGAMEDIR}
	doins -r *

	make_desktop_entry ${PN}
	make_wrapper ${PN} "./Splice.x86$(usex amd64 "_64" "")" "${MYGAMEDIR}"

	fperms +x ${MYGAMEDIR}/Splice.x86$(usex amd64 "_64" "")
}
