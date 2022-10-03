# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

SAMPLE_COMMIT=bedcbe077c4898e1b97c6c6f81d937f5048b4630
DESCRIPTION="Python library to work with PDF files"
HOMEPAGE="
	https://pypi.org/project/PyPDF2/
	https://github.com/py-pdf/PyPDF2/
"
SRC_URI="
	https://github.com/py-pdf/PyPDF2/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
	test? (
		https://github.com/py-pdf/sample-files/archive/${SAMPLE_COMMIT}.tar.gz
			-> ${PN}-sample-files-${SAMPLE_COMMIT}.gh.tar.gz
	)
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 x86"
RESTRICT="test"
# 150+ tests require network, too many to deselect
PROPERTIES="test_network"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	' 3.8 3.9)
"
BDEPEND="
	dev-python/pillow[${PYTHON_USEDEP}]
	test? (
		dev-python/pycryptodome[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# rely on -Werror
	tests/test_utils.py::test_deprecate_no_replacement
	tests/test_workflows.py::test_orientations
)

src_unpack() {
	default
	if use test; then
		mv "sample-files-${SAMPLE_COMMIT}"/* "${P}"/sample-files/ || die
	fi
}
