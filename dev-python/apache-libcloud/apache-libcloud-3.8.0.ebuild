# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="ssl(+)"

inherit distutils-r1 pypi

DESCRIPTION="Unified Interface to the Cloud - python support libs"
HOMEPAGE="
	https://libcloud.apache.org/
	https://github.com/apache/libcloud/
	https://pypi.org/project/apache-libcloud/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="examples"

RDEPEND="
	>=dev-python/requests-2.26.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/cryptography-2.6.1[${PYTHON_USEDEP}]
		dev-python/requests-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Needs network access
	libcloud/test/compute/test_ovh.py::OvhTests::test_list_nodes_invalid_region
	libcloud/test/test_connection.py::BaseConnectionClassTestCase::test_connection_timeout_raised
)

src_prepare() {
	if use examples; then
		mkdir examples || die
		mv example_*.py examples || die
	fi

	# needed for tests
	cp libcloud/test/secrets.py-dist libcloud/test/secrets.py || die

	distutils-r1_src_prepare
}

src_install() {
	use examples && dodoc -r examples
	distutils-r1_src_install
}
