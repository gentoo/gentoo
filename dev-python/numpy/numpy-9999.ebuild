# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=meson-python
PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE="threads(+)"
FORTRAN_NEEDED=lapack

inherit distutils-r1 flag-o-matic fortran-2 toolchain-funcs

DOC_PV=${PV}
# For when docs aren't ready yet, set to last version
#DOC_PV=1.23.0
DESCRIPTION="Fast array and numerical python library"
HOMEPAGE="
	https://numpy.org/
	https://github.com/numpy/numpy/
	https://pypi.org/project/numpy/
"
if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/numpy/numpy"
	inherit git-r3
else
	SRC_URI="
		mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
		doc? (
			https://numpy.org/doc/$(ver_cut 1-2 ${DOC_PV})/numpy-html.zip -> numpy-html-${DOC_PV}.zip
			https://numpy.org/doc/$(ver_cut 1-2 ${DOC_PV})/numpy-ref.pdf -> numpy-ref-${DOC_PV}.pdf
			https://numpy.org/doc/$(ver_cut 1-2 ${DOC_PV})/numpy-user.pdf -> numpy-user-${DOC_PV}.pdf
		)
	"

	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
fi

LICENSE="BSD"
SLOT="0"
IUSE="doc lapack"

RDEPEND="
	lapack? (
		>=virtual/cblas-3.8
		>=virtual/lapack-3.8
	)
"
BDEPEND="
	${RDEPEND}
	>=dev-python/cython-0.29.30[${PYTHON_USEDEP}]
	lapack? (
		virtual/pkgconfig
	)
	doc? (
		app-arch/unzip
	)
	test? (
		>=dev-python/hypothesis-5.8.0[${PYTHON_USEDEP}]
		>=dev-python/pytz-2019.3[${PYTHON_USEDEP}]
		>=dev-python/cffi-1.14.0[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-9999-meson-pyproject.toml
)

distutils_enable_tests pytest

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack
	else
		default
	fi

	if use doc; then
		unzip -qo "${DISTDIR}"/numpy-html-${DOC_PV}.zip -d html || die
	fi
}

python_prepare_all() {
	append-flags -fno-strict-aliasing

	distutils-r1_python_prepare_all
}

python_configure_all() {
	DISTUTILS_ARGS=(
		-Dblas=blas
		-Dlapack=lapack
	)
}

python_test() {
	local EPYTEST_DESELECT=(
		# very disk- and memory-hungry
		numpy/lib/tests/test_io.py::test_large_zip

		# precision problems
		numpy/core/tests/test_umath_accuracy.py::TestAccuracy::test_validate_transcendentals

		# runs the whole test suite recursively, that's just crazy
		numpy/core/tests/test_mem_policy.py::test_new_policy

		# very slow, unlikely to be practically useful
		numpy/typing/tests/test_typing.py
	)

	if use arm && [[ $(uname -m || echo "unknown") == "armv8l" ]] ; then
		# Degenerate case. arm32 chroot on arm64.
		# bug #774108
		EPYTEST_DESELECT+=(
			numpy/core/tests/test_cpu_features.py::Test_ARM_Features::test_features
		)
	fi

	if use x86 ; then
		EPYTEST_DESELECT+=(
			# https://github.com/numpy/numpy/issues/18388
			numpy/core/tests/test_umath.py::TestRemainder::test_float_remainder_overflow
			# https://github.com/numpy/numpy/issues/18387
			numpy/random/tests/test_generator_mt19937.py::TestRandomDist::test_pareto
			# more precision problems
			numpy/core/tests/test_einsum.py::TestEinsum::test_einsum_sums_int16
		)
	fi
	if use arm || use x86 ; then
		EPYTEST_DESELECT+=(
			# too large for 32-bit platforms
			numpy/core/tests/test_ufunc.py::TestUfunc::test_identityless_reduction_huge_array
		)
	fi

	cd "${T}" || die
	epytest --pyargs numpy

}

python_install_all() {
	local DOCS=( LICENSE.txt README.md THANKS.txt )

	if use doc; then
		local HTML_DOCS=( "${WORKDIR}"/html/. )
		DOCS+=( "${DISTDIR}"/${PN}-{user,ref}-${DOC_PV}.pdf )
	fi

	distutils-r1_python_install_all
}
