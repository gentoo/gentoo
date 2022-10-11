# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE="ssl(+)"

inherit distutils-r1

DESCRIPTION="Unified Interface to the Cloud - python support libs"
HOMEPAGE="https://libcloud.apache.org/"
SRC_URI="mirror://apache/${PN}/apache-${P}.tar.bz2"
S="${WORKDIR}/apache-${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="examples"

RDEPEND="
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	>=dev-python/requests-2.5.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/cryptography-2.6.1[${PYTHON_USEDEP}]
		dev-python/lockfile[${PYTHON_USEDEP}]
		dev-python/requests-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Needs network access
	libcloud/test/compute/test_ovh.py::OvhTests::test_list_nodes_invalid_region
	libcloud/test/test_connection.py::BaseConnectionClassTestCase::test_connection_timeout_raised
	libcloud/test/test_connection.py::ConnectionClassTestCase::test_retry_on_all_default_retry_exception_classes
	# TODO
	libcloud/test/compute/test_ssh_client.py::ParamikoSSHClientTests::test_key_file_non_pem_format_error
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
