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

	SRC_URI="
		mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
		doc? (
			https://docs.scipy.org/doc/${PN}-${DOC_PV}/${PN}-html-${DOC_PV}.zip
			https://docs.scipy.org/doc/${PN}-${DOC_PV}/${PN}-ref-${DOC_PV}.pdf
		)"

	KEYWORDS="~amd64 ~arm ~arm64 -hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

LICENSE="BSD LGPL-2"
SLOT="0"
IUSE="doc +sparse"

DEPEND="
	>=dev-python/numpy-1.17.3[lapack,${PYTHON_USEDEP}]
	sci-libs/arpack:0=
	virtual/cblas
	virtual/lapack
	sparse? ( sci-libs/umfpack:0= )"
RDEPEND="${DEPEND}
	dev-python/pillow[${PYTHON_USEDEP}]"
# TODO: restore pythran optionality?
BDEPEND="
	dev-lang/swig
	>=dev-python/cython-0.29.18[${PYTHON_USEDEP}]
	dev-python/pybind11[${PYTHON_USEDEP}]
	dev-python/pythran[${PYTHON_USEDEP}]
	dev-util/patchelf
	virtual/pkgconfig
	doc? ( app-arch/unzip )
	test? ( dev-python/pytest-xdist[${PYTHON_USEDEP}] )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.9.9999-meson-options-lapack.patch
)

distutils_enable_tests pytest

python_test() {
	cd "${T}" || die

	epytest -n "$(makeopts_jobs)" --pyargs scipy
}
