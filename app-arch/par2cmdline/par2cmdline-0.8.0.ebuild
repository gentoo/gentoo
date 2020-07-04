# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A PAR-2.0 file verification and repair tool"
HOMEPAGE="https://github.com/Parchive/par2cmdline"
SRC_URI="https://github.com/Parchive/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="openmp"

DOCS="AUTHORS ChangeLog README" # NEWS is empty, PORTING and ROADMAP are for building

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_test() {
	# test22 fails when run in parallel
	emake -j1 check
}
