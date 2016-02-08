# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

DESCRIPTION="Assembly By Short Sequences - a de novo, parallel, paired-end sequence assembler"
HOMEPAGE="http://www.bcgsc.ca/platform/bioinfo/software/abyss/"
SRC_URI="http://www.bcgsc.ca/downloads/abyss/${P}.tar.gz"

LICENSE="abyss"
SLOT="0"
IUSE="+mpi openmp misc-haskell"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-cpp/sparsehash
	dev-libs/boost
	misc-haskell? ( dev-libs/gmp:0=
			virtual/libffi:0=
	)
	mpi? ( virtual/mpi )
"
DEPEND="${RDEPEND}
	misc-haskell? ( dev-lang/ghc
			dev-haskell/mmap )
"

# todo: --enable-maxk=N configure option
# todo: fix automagic mpi toggling

PATCHES=(
	"${FILESDIR}"/${P}-gcc-4.7.patch
	"${FILESDIR}"/${P}-ac_prog_ar.patch
	)

src_prepare() {
	tc-export AR
	sed -i -e "s/-Werror//" configure.ac || die #365195
	sed -i -e "/dist_pkgdoc_DATA/d" Makefile.am || die
	autotools-utils_src_prepare
}

src_configure() {
	# disable building haskell tool Misc/samtobreak
	# unless request by user: bug #534412
	use misc-haskell || export ac_cv_prog_ac_ct_GHC=

	local myeconfargs=(
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
		$(use_enable openmp)
	)
	autotools-utils_src_configure
}
