# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Maximum likelihood analysis for nucleotide, amino acid, and two-state data"
HOMEPAGE="http://www.tree-puzzle.de"
SRC_URI="http://www.tree-puzzle.de/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="mpi"
RESTRICT="test"

DEPEND="mpi? ( virtual/mpi )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-C99-decls.patch
	"${FILESDIR}"/${P}-MPI-3.0.patch
	"${FILESDIR}"/${P}-configure-c99.patch
)

src_prepare() {
	default
	eautoreconf
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

src_compile() {
	# hopelessly terrible build system, abuses Automake
	emake -j1
}

src_install() {
	dobin src/puzzle $(usev mpi src/ppuzzle)

	einstalldocs

	# User manual
	dodoc doc/tree-puzzle.pdf

	# Example data files
	insinto /usr/share/${PN}/data
	rm data/Makefile* || die
	doins -r data/.
}
