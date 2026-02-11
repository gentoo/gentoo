# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )
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

# Includes optional driver dependencies that are also test dependencies.
RDEPEND="
	>=dev-python/cryptography-44.0.2[${PYTHON_USEDEP}]
	dev-python/fasteners[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-25.0.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.26.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/requests-mock[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
EPYTEST_XDIST=1
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	if use examples; then
		mkdir examples || die
		mv example_*.py examples || die
	fi

	# needed for tests
	cp libcloud/test/secrets.py-dist libcloud/test/secrets.py || die
}

python_test() {
	local EPYTEST_DESELECT=(
		# TODO
		libcloud/test/test_init.py::TestUtils::test_init_once_and_debug_mode
		libcloud/test/common/test_openstack_identity.py::OpenStackIdentityConnectionTestCase::test_token_expiration_and_force_reauthenti
	)
	local EPYTEST_IGNORE=(
		libcloud/test/benchmarks
		# broken by modern paramiko
		libcloud/test/compute/test_ssh_client.py
	)

	local -x NO_INTERNET=1
	epytest
}

src_install() {
	use examples && dodoc -r examples
	distutils-r1_src_install
}
