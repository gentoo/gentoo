# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=meson-python
PYTHON_COMPAT=( python3_{8..10} )
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
	# Upstream is often behind with doc updates
	DOC_PV=1.8.1
	MY_PV=${PV/_rc/rc}
	MY_P=${PN}-${MY_PV}

	SRC_URI="
		mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz
		doc? (
			https://docs.scipy.org/doc/${PN}-${DOC_PV}/${PN}-html-${DOC_PV}.zip
			https://docs.scipy.org/doc/${PN}-${DOC_PV}/${PN}-ref-${DOC_PV}.pdf
		)"
	S="${WORKDIR}"/${MY_P}

	if [[ ${PV} != *rc* ]] ; then
		KEYWORDS="~amd64 -hppa ~ppc64 ~riscv"
	fi
fi

LICENSE="BSD LGPL-2"
SLOT="0"
IUSE="doc"

# umfpack is technically optional but it's preferred to have it available.
DEPEND="
	>=dev-python/numpy-1.18.5[lapack,${PYTHON_USEDEP}]
	sci-libs/arpack:=
	sci-libs/umfpack
	virtual/cblas
	>=virtual/lapack-3.8
"
RDEPEND="
	${DEPEND}
	dev-python/pillow[${PYTHON_USEDEP}]
"
# TODO: restore pythran optionality?
BDEPEND="
	dev-lang/swig
	>=dev-python/cython-0.29.18[${PYTHON_USEDEP}]
	dev-python/pybind11[${PYTHON_USEDEP}]
	dev-python/pythran[${PYTHON_USEDEP}]
	>=dev-util/meson-0.62.2
	dev-util/patchelf
	virtual/pkgconfig
	doc? ( app-arch/unzip )
	test? ( dev-python/pytest-xdist[${PYTHON_USEDEP}] )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.9.9999-meson-options-lapack.patch
)

EPYTEST_DESELECT=(
	linalg/tests/test_decomp.py::TestSchur::test_sort
	linalg/tests/test_solvers.py::test_solve_discrete_are
)

distutils_enable_tests pytest

python_test() {
	cd "${T}" || die

	epytest -n "$(makeopts_jobs)" --pyargs scipy
}

python_install_all() {
	use doc && \
		local DOCS=( "${DISTDIR}"/${PN}-ref-${DOC_PV}.pdf ) \
		local HTML_DOCS=( "${WORKDIR}"/html/. )

	distutils-r1_python_install_all
}
