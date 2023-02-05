# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

MY_P=${P/_p/.post}
DESCRIPTION="Python library to work with pdf files based on qpdf"
HOMEPAGE="
	https://github.com/pikepdf/pikepdf/
	https://pypi.org/project/pikepdf/
"
SRC_URI="
	https://github.com/${PN}/${PN}/archive/v${PV/_p/.post}.tar.gz
		-> ${P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

DEPEND="
	>=app-text/qpdf-11.1.1:0=
"
RDEPEND="
	${DEPEND}
	dev-python/deprecation[${PYTHON_USEDEP}]
	>=dev-python/lxml-4.0[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/pillow-9.0[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/pybind11-2.10.1[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm-7.0.5[${PYTHON_USEDEP}]
	test? (
		>=dev-python/attrs-20.2.0[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-6.36[${PYTHON_USEDEP}]
		>=dev-python/pillow-5.0.0[${PYTHON_USEDEP},jpeg,lcms,tiff]
		>=dev-python/psutil-5.9[${PYTHON_USEDEP}]
		>=dev-python/pytest-timeout-2.1.0[${PYTHON_USEDEP}]
		>=dev-python/python-dateutil-2.8.1[${PYTHON_USEDEP}]
		>=dev-python/python-xmp-toolkit-2.0.1[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/tomli[${PYTHON_USEDEP}]
		' 3.{8..10})
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# fragile to system load
	tests/test_image_access.py::test_random_image
)

src_prepare() {
	sed -e '/-n auto/d' -i pyproject.toml || die
	distutils-r1_src_prepare
}
