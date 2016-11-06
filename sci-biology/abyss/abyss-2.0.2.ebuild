# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools toolchain-funcs

DESCRIPTION="Assembly By Short Sequences - a de novo, parallel, paired-end sequence assembler"
HOMEPAGE="http://www.bcgsc.ca/platform/bioinfo/software/abyss/"
SRC_URI="https://github.com/bcgsc/abyss/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="abyss"
SLOT="0"
IUSE="+mpi openmp misc-haskell"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-cpp/sparsehash
	dev-libs/boost:=
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

src_prepare() {
	default
	sed -i -e "s/-Werror//" configure.ac || die #365195
	sed -i -e "/dist_pkgdoc_DATA/d" Makefile.am || die
	eautoreconf
}

src_configure() {
	# disable building haskell tool Misc/samtobreak
	# unless request by user: bug #534412
	use misc-haskell || export ac_cv_prog_ac_ct_GHC=

	econf $(use_enable openmp)
}
