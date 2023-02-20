# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FORTRAN_NEEDED=fortran
DISTUTILS_USE_PEP517=meson-python
PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="threads(+)"

inherit fortran-2 distutils-r1 multiprocessing

DESCRIPTION="Scientific algorithms library for Python"
HOMEPAGE="
	https://scipy.org/
	https://github.com/scipy/scipy/
	https://pypi.org/project/scipy/
"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3

	# Need submodules, so git for now.
	EGIT_REPO_URI="https://github.com/scipy/scipy"
	EGIT_BRANCH="maintenance/$(ver_cut 1-2).x"
	EGIT_SUBMODULES=( '*' )
else
	inherit pypi

	# Upstream is often behind with doc updates
	DOC_PV=${PV}

	SRC_URI+="
		doc? (
			https://docs.scipy.org/doc/${PN}-${DOC_PV}/${PN}-html-${DOC_PV}.zip
		)"

	if [[ ${PV} != *rc* ]] ; then
		KEYWORDS="~amd64 ~arm ~arm64 -hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
	fi
fi

LICENSE="BSD LGPL-2"
SLOT="0"
IUSE="doc +fortran test-rust"

# umfpack is technically optional but it's preferred to have it available.
DEPEND="
	>=dev-python/numpy-1.19.5[lapack,${PYTHON_USEDEP}]
	sci-libs/arpack:=
	sci-libs/umfpack
	virtual/cblas
	>=virtual/lapack-3.8
"
RDEPEND="
	${DEPEND}
	dev-python/pillow[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-lang/swig
	>=dev-python/cython-0.29.18[${PYTHON_USEDEP}]
	>=dev-python/meson-python-0.11[${PYTHON_USEDEP}]
	dev-python/pybind11[${PYTHON_USEDEP}]
	>=dev-util/meson-0.62.2
	dev-util/patchelf
	virtual/pkgconfig
	doc? ( app-arch/unzip )
	fortran? ( dev-python/pythran[${PYTHON_USEDEP}] )
	test? (
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)
	test-rust? (
		dev-python/pooch[${PYTHON_USEDEP}]
	)
"

EPYTEST_DESELECT=(
	linalg/tests/test_decomp.py::TestSchur::test_sort
	linalg/tests/test_solvers.py::test_solve_discrete_are
	optimize/tests/test_milp.py::test_milp_timeout_16545

	# Network
	datasets/tests/test_data.py::TestDatasets::test_existence_all
	datasets/tests/test_data.py::TestDatasets::test_ascent
	datasets/tests/test_data.py::TestDatasets::test_face
	datasets/tests/test_data.py::TestDatasets::test_electrocardiogram
)

distutils_enable_tests pytest

src_unpack() {
	default

	if use doc; then
		unzip -qo "${DISTDIR}"/${PN}-html-${DOC_PV}.zip -d html || die
	fi
}

python_configure_all() {
	export SCIPY_USE_PYTHRAN=$(usex fortran 1 0)
	DISTUTILS_ARGS=(
		-Dblas=blas
		-Dlapack=lapack
	)
}

python_test() {
	cd "${T}" || die

	if ! has_version -b "dev-python/pooch[${PYTHON_USEDEP}]" ; then
		EPYTEST_IGNORE+=(
			datasets/tests/test_data.py
		)
	fi

	epytest -n "$(makeopts_jobs)" --pyargs scipy
}

python_install_all() {
	use doc && local HTML_DOCS=( "${WORKDIR}"/html/. )

	distutils-r1_python_install_all
}
