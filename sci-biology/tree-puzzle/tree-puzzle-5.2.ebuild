# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Maximum likelihood analysis for nucleotide, amino acid, and two-state data"
HOMEPAGE="http://www.tree-puzzle.de"
SRC_URI="http://www.tree-puzzle.de/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="mpi"
RESTRICT="test"

DEPEND="mpi? ( virtual/mpi )"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-impl-dec.patch )

pkg_setup() {
	use mpi && [[ $(tc-getCC) == icc* ]] &&
		die "The parallelized version of tree-puzzle cannot be compiled using icc.
			Either disable the \"mpi\" USE flag to compile only the non-parallelized
			version of the program, or use gcc as your compiler (CC=\"gcc\")."
}

src_configure() {
	default

	if ! use mpi; then
		sed \
			-e 's:bin_PROGRAMS = puzzle$(EXEEXT) ppuzzle:bin_PROGRAMS = puzzle :' \
			-e 's:DIST_SOURCES = $(ppuzzle_SOURCES) $(puzzle_SOURCES):DIST_SOURCES = $(puzzle_SOURCES):' \
			-i src/Makefile || die
	fi
}

src_install() {
	dobin src/puzzle
	use mpi && dobin src/ppuzzle
	einstalldocs

	# User manual
	dodoc doc/tree-puzzle.pdf

	# Example data files
	insinto /usr/share/${PN}/data
	rm data/Makefile* || die
	doins -r data/.
}
