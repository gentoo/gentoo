# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FORTRAN_NEEDED=fortran
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=meson-python
PYTHON_COMPAT=( python3_{10..11} )
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
	#DOC_PV=${PV}
	DOC_PV=1.11.0

	SRC_URI+="
		doc? (
			https://docs.scipy.org/doc/${PN}-${DOC_PV}/${PN}-html-${DOC_PV}.zip
		)"

	if [[ ${PV} != *rc* ]] ; then
		KEYWORDS="~amd64 ~arm ~arm64 -hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos"
	fi
fi

LICENSE="BSD LGPL-2"
SLOT="0"
IUSE="doc +fortran test-rust"

# umfpack is technically optional but it's preferred to have it available.
DEPEND="
	>=dev-python/numpy-1.21.6[lapack,${PYTHON_USEDEP}]
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
	>=dev-python/cython-0.29.35[${PYTHON_USEDEP}]
	>=dev-python/meson-python-0.12.1[${PYTHON_USEDEP}]
	>=dev-python/pybind11-2.10.4[${PYTHON_USEDEP}]
	>=dev-util/meson-1.1.0
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

distutils_enable_tests pytest

PATCHES=(
	# https://github.com/scipy/scipy/pull/18810
	"${FILESDIR}/${P}-cython-3.patch"
)

src_unpack() {
	default

	if use doc; then
		unzip -qo "${DISTDIR}"/${PN}-html-${DOC_PV}.zip -d html || die
	fi
}

python_configure_all() {
	DISTUTILS_ARGS=(
		-Dblas=blas
		-Dlapack=lapack
		-Duse-pythran=$(usex fortran true false)
	)
}

python_test() {
	cd "${BUILD_DIR}/install$(python_get_sitedir)" || die

	local EPYTEST_DESELECT=(
		# Network
		scipy/datasets/tests/test_data.py::TestDatasets::test_existence_all
		scipy/datasets/tests/test_data.py::TestDatasets::test_ascent
		scipy/datasets/tests/test_data.py::TestDatasets::test_face
		scipy/datasets/tests/test_data.py::TestDatasets::test_electrocardiogram

		# Precision issue with diff. blas?
		scipy/optimize/tests/test__basinhopping.py::Test_Metropolis::test_gh7799
	)
	local EPYTEST_IGNORE=()

	if ! has_version -b "dev-python/pooch[${PYTHON_USEDEP}]" ; then
		EPYTEST_IGNORE+=(
			scipy/datasets/tests/test_data.py
		)
	fi

	epytest -n "$(makeopts_jobs)" scipy
}

python_install_all() {
	use doc && local HTML_DOCS=( "${WORKDIR}"/html/. )

	distutils-r1_python_install_all
}
