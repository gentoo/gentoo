# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/pikepdf/pikepdf
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Python library to work with pdf files based on qpdf"
HOMEPAGE="
	https://github.com/pikepdf/pikepdf/
	https://pypi.org/project/pikepdf/
"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="big-endian"

# Check QPDF_MIN_VERSION in pyproject.toml on bumps, as well as
# https://qpdf.readthedocs.io/en/stable/release-notes.html.
DEPEND="
	>=app-text/qpdf-12.2.0:0=
"
RDEPEND="
	${DEPEND}
	dev-python/deprecated[${PYTHON_USEDEP}]
	>=dev-python/lxml-4.0[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/pillow-10.0.1[lcms,${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/pybind11-3[${PYTHON_USEDEP}]
	>=dev-python/setuptools-77.0.3[${PYTHON_USEDEP}]
	>=dev-python/setuptools-scm-7.0.5[${PYTHON_USEDEP}]
	test? (
		>=dev-python/attrs-20.2.0[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.21.0[${PYTHON_USEDEP}]
		>=dev-python/pillow-5.0.0[${PYTHON_USEDEP},jpeg,lcms,tiff]
		>=dev-python/psutil-5.9[${PYTHON_USEDEP}]
		>=dev-python/python-dateutil-2.8.1[${PYTHON_USEDEP}]
		!big-endian? (
			>=dev-python/python-xmp-toolkit-2.0.1[${PYTHON_USEDEP}]
		)
		media-libs/tiff[zlib]
	)
"

EPYTEST_PLUGINS=( hypothesis pytest-timeout )
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	sed -e '/-n auto/d' -i pyproject.toml || die
}

python_test() {
	local EPYTEST_DESELECT=()

	case ${EPYTHON} in
		pypy3.11)
			EPYTEST_DESELECT+=(
				# mismatched exception message
				tests/test_scalar_types.py::TestIntIntConversions::test_index_on_non_integer_raises
			)
			;;
	esac

	epytest
}
