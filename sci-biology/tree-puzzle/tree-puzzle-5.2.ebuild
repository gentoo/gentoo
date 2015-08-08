# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="Maximum likelihood analysis for nucleotide, amino acid, and two-state data"
HOMEPAGE="http://www.tree-puzzle.de"
SRC_URI="http://www.tree-puzzle.de/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="mpi"

DEPEND="mpi? ( virtual/mpi )"
RDEPEND="${DEPEND}"

RESTRICT="test"

pkg_setup () {
	use mpi && [ $(tc-getCC) = icc ] && die "The parallelized version of tree-puzzle cannot be compiled using icc.
	Either disable the \"mpi\" USE flag to compile only the non-parallelized
	version of the program, or use gcc as your compiler (CC=\"gcc\")."
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-impl-dec.patch
}

src_configure() {
	default

	if ! use mpi; then
			sed \
				-e 's:bin_PROGRAMS = puzzle$(EXEEXT) ppuzzle:bin_PROGRAMS = puzzle :' \
				-e 's:DIST_SOURCES = $(ppuzzle_SOURCES) $(puzzle_SOURCES):DIST_SOURCES = $(puzzle_SOURCES):' \
				-i "${S}"/src/Makefile || die
	fi
}

src_install() {
	dobin src/puzzle
	use mpi && dobin src/ppuzzle
	dodoc AUTHORS ChangeLog README

	# User manual
	insinto /usr/share/doc/${PF}
	doins doc/tree-puzzle.pdf

	# Example data files
	insinto /usr/share/${PN}/data
	rm data/Makefile*
	doins data/*
}
