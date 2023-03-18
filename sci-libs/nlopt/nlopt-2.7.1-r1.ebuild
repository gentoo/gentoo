# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )
FORTRAN_NEEDED="test"

inherit python-r1 cmake fortran-2

DESCRIPTION="Non-linear optimization library"
HOMEPAGE="https://github.com/stevengj/nlopt"
SRC_URI="https://github.com/stevengj/nlopt/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1 MIT"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="cxx guile octave python test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

RDEPEND="
	guile? ( dev-scheme/guile:* )
	octave? ( >=sci-mathematics/octave-6 )
	python? (
		${PYTHON_DEPS}
		dev-python/numpy[${PYTHON_USEDEP}]
	)
	"
DEPEND="${RDEPEND}"
BDEPEND="python? ( dev-lang/swig )"

src_prepare() {
	cmake_src_prepare

	use python && python_copy_sources
}

src_configure() {
	# MATLAB detection causes problems (as in bug 826774) if we don't
	# explicitly disable it.
	local mycmakeargs=(
		-DNLOPT_CXX=$(usex cxx)
		-DNLOPT_FORTRAN=$(usex test)
		-DNLOPT_GUILE=$(usex guile)
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
		local a f
		cd "${BUILD_DIR}"/test
		for a in {1..$(usex cxx 9 7)}; do
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

	if use python; then
		python_foreach_impl run_in_build_dir nlopt_install
	fi

	local r
	for r in */README; do
		newdoc ${r} README.$(dirname ${r})
	done
}
