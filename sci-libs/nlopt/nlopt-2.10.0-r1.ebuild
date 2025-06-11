# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_COMPAT=( 2-2 3-0 )
PYTHON_COMPAT=( python3_{11..14} )
FORTRAN_NEEDED="test"

inherit python-r1 cmake guile-single fortran-2

DESCRIPTION="Non-linear optimization library"
HOMEPAGE="https://github.com/stevengj/nlopt"
SRC_URI="https://github.com/stevengj/nlopt/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"
IUSE="guile octave python test"
REQUIRED_USE="guile? ( ${GUILE_REQUIRED_USE} ) python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

RDEPEND="
	guile? ( ${GUILE_DEPS} )
	octave? ( >=sci-mathematics/octave-6:= )
	python? (
		${PYTHON_DEPS}
		dev-python/numpy[${PYTHON_USEDEP}]
	)
"
DEPEND="${RDEPEND}"
BDEPEND="python? ( dev-lang/swig )"

PATCHES=(
	"${FILESDIR}"/${P}-libm.patch
	"${FILESDIR}"/${P}-cxx.patch
	"${FILESDIR}"/${P}-libm-pc.patch
)

pkg_setup() {
	use guile && guile-single_pkg_setup
	fortran-2_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	use guile && guile_bump_sources
	use python && python_copy_sources
}

src_configure() {
	# MATLAB detection causes problems (as in bug #826774) if we don't
	# explicitly disable it.
	local mycmakeargs=(
		-DNLOPT_CXX=ON
		-DNLOPT_FORTRAN=$(usex test)
		-DNLOPT_GUILE=$(usex guile)
		-DNLOPT_JAVA=OFF
		-DNLOPT_OCTAVE=$(usex octave)
		-DNLOPT_MATLAB=OFF
		-DNLOPT_PYTHON=OFF
		-DNLOPT_SWIG=$(usex python)
		-DNLOPT_TESTS=$(usex test)
	)

	cmake_src_configure

	if use python; then
		python_configure() {
			local mycmakeargs=(
				${mycmakeargs[@]}
				-DNLOPT_PYTHON=ON
				-DINSTALL_PYTHON_DIR="$(python_get_sitedir)"
			)

			cmake_src_configure
		}

		python_foreach_impl run_in_build_dir python_configure
	fi
}

src_compile() {
	cmake_src_compile

	if use python; then
		python_foreach_impl run_in_build_dir cmake_src_compile
	fi
}

src_test() {
	do_test() {
		cd "${BUILD_DIR}"/test || die

		local a f
		for a in {1..9}; do
			for f in {5..9}; do
				./testopt -a $a -o $f || die "algorithm $a function $f failed"
			done
		done
	}

	do_test

	if use python; then
		python_foreach_impl run_in_build_dir do_test
	fi
}

nlopt_install() {
	cmake_src_install
	python_optimize
}

src_install() {
	cmake_src_install

	guile_unstrip_ccache
	if use python; then
		python_foreach_impl run_in_build_dir nlopt_install
	fi

	local r
	for r in */README; do
		newdoc ${r} README.$(dirname ${r})
	done
}
