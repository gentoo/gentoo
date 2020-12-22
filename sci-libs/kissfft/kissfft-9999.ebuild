# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit cmake python-any-r1

DESCRIPTION="A Fast Fourier Transform (FFT) library that tries to Keep it Simple, Stupid"
HOMEPAGE="https://github.com/mborgerding/kissfft"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/mborgerding/kissfft"
	inherit git-r3
else
	SRC_URI="https://github.com/mborgerding/kissfft/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD"
IUSE="test"
SLOT="0"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		sci-libs/fftw:3.0
		$(python_gen_any_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
		')
	)
"

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DKISSFFT_TOOLS=OFF
	)

	cmake_src_configure
}

python_check_deps() {
	has_version -d "dev-python/numpy[${PYTHON_USEDEP}]"
}
