# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )

inherit cmake python-any-r1 toolchain-funcs

DESCRIPTION="A Fast Fourier Transform (FFT) library that tries to Keep it Simple, Stupid"
HOMEPAGE="https://github.com/mborgerding/kissfft"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/mborgerding/kissfft"
	inherit git-r3
else
	SRC_URI="https://github.com/mborgerding/kissfft/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE="alloca cpu_flags_x86_sse openmp test tools"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		sci-libs/fftw:3.0
		$(python_gen_any_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
		')
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-131.1.0-cross.patch
)

python_check_deps() {
	python_has_version -d "dev-python/numpy[${PYTHON_USEDEP}]"
}

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	local mycmakeargs=(
		-DKISSFFT_OPENMP=$(usex openmp 1 0)
		-DKISSFFT_TEST=$(usex test)
		-DKISSFFT_TOOLS=$(usex tools)
		-DKISSFFT_USE_ALLOCA=$(usex alloca)
		-DKISSFFT_DATATYPE=$(usex cpu_flags_x86_sse simd float)
	)

	cmake_src_configure
}
