# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

SAMPLE_COMMIT=2cf1e75af7bcb9c097deae6fb112c715d4721744
DESCRIPTION="Python library to work with PDF files"
HOMEPAGE="
	https://pypi.org/project/pypdf/
	https://github.com/py-pdf/pypdf/
"
SRC_URI="
	https://github.com/py-pdf/pypdf/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
	test? (
		https://github.com/py-pdf/sample-files/archive/${SAMPLE_COMMIT}.tar.gz
			-> ${PN}-sample-files-${SAMPLE_COMMIT}.gh.tar.gz
	)
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

BDEPEND="
	test? (
		dev-python/pillow[jpeg,jpeg2k,tiff,${PYTHON_USEDEP}]
		dev-python/pycryptodome[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# rely on -Werror
	tests/test_utils.py::test_deprecate_no_replacement
	tests/test_workflows.py::test_orientations
	# TODO: requires fpdf
	tests/test_page.py::test_compression
)

src_unpack() {
	default
	if use test; then
		mv "sample-files-${SAMPLE_COMMIT}"/* "${S}"/sample-files/ || die
	fi
}

python_test() {
	epytest -o addopts= -m "not enable_socket"
}
