# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools toolchain-funcs

DESCRIPTION="Assembler/scaffolder for paired-end and mate-pair reads"
HOMEPAGE="http://www.bcgsc.ca/platform/bioinfo/software/abyss
	https://github.com/bcgsc/abyss"
SRC_URI="https://github.com/bcgsc/abyss/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="abyss"
SLOT="0"
IUSE="boost bwa misc-haskell mpi mpich openmp sparsehash sqlite"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	sparsehash? ( dev-cpp/sparsehash )
	boost? ( dev-libs/boost:= )
	sqlite? ( dev-db/sqlite:3 )
	mpi? ( sys-cluster/openmpi )
	bwa? ( sci-biology/bwa )
	misc-haskell? (
		dev-libs/gmp:0=
		virtual/libffi:0=
	)"
DEPEND="${RDEPEND}
	misc-haskell? (
		dev-lang/ghc
		dev-haskell/mmap
	)"

# todo: --enable-maxk=N configure option should be exposed to parent shell
#         of emerge so that user can change the value easily
# todo: fix automagic mpi toggling

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

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

	# bug #646478 , also where is mpich2 switch?
	#  --enable-mpich          use MPICH (default is to use Open MPI)
	#  --enable-lammpi         use LAM/MPI (default is to use Open MPI)
	#
	# --enable-maxk=N configure option, supported values must be
	#   multiple of 32, i.e. 32, 64, 96, 128, etc., configure of
	#   version 2.0.2 shows default value is 128 these days,
	#   version 2.0.3 has default 144
	econf $(use_enable openmp) \
		$(use_enable mpich) \
		$(use_with sqlite) \
		$(use_with mpi) \
		$(use_with boost) \
		$(use_with sparsehash ) \
		--enable-maxk=192
}
