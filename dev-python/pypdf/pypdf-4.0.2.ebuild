# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

SAMPLE_COMMIT=964fb47b0fbfa89864680582640ae4eedf143890
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
		dev-python/cryptography[${PYTHON_USEDEP}]
		>=dev-python/pillow-8.0.0[jpeg,jpeg2k,tiff,zlib,${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_unpack() {
	default
	if use test; then
		mv "sample-files-${SAMPLE_COMMIT}"/* "${S}"/sample-files/ || die
	fi
}

python_test() {
	local EPYTEST_DESELECT=(
		tests/test_reader.py::test_decode_permissions
		tests/test_workflows.py::test_text_extraction_layout_mode
		# rely on -Werror
		tests/test_utils.py::test_deprecate_no_replacement
		tests/test_workflows.py::test_orientations
		tests/test_writer.py::test_remove_image_per_type
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -o addopts= -m "not enable_socket"
}
