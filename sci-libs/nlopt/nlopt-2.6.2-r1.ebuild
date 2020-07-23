# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit python-r1 cmake fortran-2

DESCRIPTION="Non-linear optimization library"
HOMEPAGE="https://ab-initio.mit.edu/nlopt/"
SRC_URI="https://github.com/stevengj/nlopt/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1 MIT"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="cxx guile octave python static-libs test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

RDEPEND="
	guile? ( dev-scheme/guile:* )
	octave? ( sci-mathematics/octave )
	python? (
		${PYTHON_DEPS}
		dev-python/numpy[${PYTHON_USEDEP}]
	)
	"
DEPEND="
	${RDEPEND}
	python? ( dev-lang/swig )
	"

src_prepare() {
	cmake_src_prepare
	use python && python_copy_sources
}

src_configure() {
	local mycmakeargs=(
		-DNLOPT_CXX=$(usex cxx)
		-DNLOPT_FORTRAN=$(usex test)
		-DNLOPT_GUILE=$(usex guile)
		-DNLOPT_OCTAVE=$(usex octave)
		-DNLOPT_PYTHON=$(usex python)
		-DNLOPT_SWIG=$(usex python)
		-DNLOPT_TESTS=$(usex test)
	)
	if use python; then
		python_foreach_impl run_in_build_dir cmake_src_configure
	else
		cmake_src_configure
	fi
	if use static-libs; then
		mycmakeargs+=(
			-DBUILD_SHARED_LIBS=OFF
		)
		BUILD_DIR="${S}_static-libs" run_in_build_dir cmake_src_configure
	fi
}

src_compile() {
	if use python; then
		python_foreach_impl run_in_build_dir cmake_src_compile
	else
		cmake_src_compile
	fi
	if use static-libs; then
		BUILD_DIR="${S}_static-libs" run_in_build_dir cmake_src_compile
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
	if use python; then
		python_foreach_impl run_in_build_dir do_test
	else
		do_test
	fi
	if use static-libs; then
		BUILD_DIR="${S}_static-libs" run_in_build_dir do_test
	fi
}

nlopt_install() {
	cmake_src_install
	python_optimize
}

src_install() {
	if use python; then
		python_foreach_impl run_in_build_dir nlopt_install
	else
		cmake_src_install
	fi
	if use static-libs; then
		BUILD_DIR="${S}_static-libs" run_in_build_dir dolib.a libnlopt.a
	fi
	local r
	for r in */README; do newdoc ${r} README.$(dirname ${r}); done
}
