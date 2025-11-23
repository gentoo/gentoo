# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

MY_P="tkMOO-light-${PV}"

DESCRIPTION="MOO Client written in Tcl/Tk"
HOMEPAGE="http://www.awns.com/tkMOO-light/"
SRC_URI="http://www.awns.com/tkMOO-light/Source/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="tkMOO"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-lang/tcl
	dev-lang/tk
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PV}-Makefile-noclean.patch"
	"${FILESDIR}/${PV}-keys-workaround.patch"
)

src_compile() {
	local myemakeargs=(
		WISH="$(type -P wish)"
		TKMOO_LIB_DIR="${EPREFIX}/usr/share/${PN}"
		TKMOO_BIN_DIR="${EPREFIX}/usr/bin"
	)
	emake "${myemakeargs[@]}"
}

src_install() {
	local emakeargs=(
		TKMOO_LIB_DIR="${ED}/usr/share/${PN}"
		TKMOO_BIN_DIR="${ED}/usr/bin"
	)
	emake "${emakeargs[@]}" install

	dodoc README dot.tkmoolightrc bugsmail.txt
	dosym tkMOO-lite /usr/bin/tkmoo
	make_desktop_entry tkmoo "tkMOO" applications-games
}
