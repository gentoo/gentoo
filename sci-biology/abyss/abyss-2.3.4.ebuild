# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="Assembly By Short Sequences - a de novo, parallel, paired-end sequence assembler"
HOMEPAGE="https://www.bcgsc.ca/resources/software/abyss/"
SRC_URI="https://github.com/bcgsc/abyss/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE="openmp misc-haskell"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-cpp/sparsehash
	dev-libs/boost:=
	misc-haskell? (
		dev-libs/gmp:0=
		dev-libs/libffi:0=
	)
	sys-cluster/openmpi
	dev-db/sqlite:3
"
DEPEND="${RDEPEND}
	misc-haskell? (
		dev-lang/ghc
	)
"

# todo: --enable-maxk=N configure option
# todo: also allow build with mpich (--enable-mpich)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	default
	sed -i -e "s/-Werror//" configure.ac || die #365195
	eautoreconf
}

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/862252
	# https://github.com/bcgsc/abyss/issues/474
	filter-lto

	# disable building haskell tool Misc/samtobreak
	# unless request by user: bug #534412
	use misc-haskell || export ac_cv_prog_ac_ct_GHC=

	econf $(use_enable openmp) --enable-maxk=256
}
