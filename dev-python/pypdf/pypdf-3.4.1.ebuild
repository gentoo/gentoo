# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

SAMPLE_COMMIT=0fe84b30ed33ff3daa9293e44349b8618f135699
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
S=${WORKDIR}/pypdf-${PV}

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
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
		mv "sample-files-${SAMPLE_COMMIT}"/* "${S}"/sample-files/ || die
	fi
}
