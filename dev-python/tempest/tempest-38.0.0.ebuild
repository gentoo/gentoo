# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 multiprocessing pypi

DESCRIPTION="OpenStack Integration Testing"
HOMEPAGE="
	https://pypi.org/project/tempest/
	https://docs.openstack.org/tempest/latest/
	https://launchpad.net/tempest/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>dev-python/pbr-2.1.0[${PYTHON_USEDEP}]
	>dev-python/cliff-2.9.0[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-3.2.0[${PYTHON_USEDEP}]
	>=dev-python/testtools-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/paramiko-2.7.0[${PYTHON_USEDEP}]
	>=dev-python/netaddr-0.7.18[${PYTHON_USEDEP}]
	>=dev-python/oslo-concurrency-3.26.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-5.2.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-log-3.36.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-4.7.0[${PYTHON_USEDEP}]
	>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.12[${PYTHON_USEDEP}]
	>=dev-python/subunit-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.20.0[${PYTHON_USEDEP}]
	>=dev-python/prettytable-0.7.1[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.21.1[${PYTHON_USEDEP}]
	>=dev-python/debtcollector-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/defusedxml-0.7.1[${PYTHON_USEDEP}]
	>=dev-python/fasteners-0.16.0[${PYTHON_USEDEP}]
"
BDEPEND="
	>dev-python/pbr-2.1.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/oslotest-3.2.0[${PYTHON_USEDEP}]
		dev-python/stestr[${PYTHON_USEDEP}]
	)
"

src_prepare() {
	# Small subset of tests, which fail as result of not using specific
	# testing environment.
	rm -r tempest/tests/lib/services/volume/v3/ || die

	# remove dep on hacking
	rm tempest/tests/test_hacking.py || die

	distutils-r1_src_prepare
}

python_compile() {
	distutils-r1_python_compile
	mv "${BUILD_DIR}"/install/{usr/,}etc || die
}

python_test() {
	local -x OS_LOG_CAPTURE=1 OS_STDOUT_CAPTURE=1 OS_STDERR_CAPTURE=1
	local -x OS_TEST_TIMEOUT=300
	stestr --test-path ./tempest/tests run --concurrency="$(makeopts_jobs)" ||
		die "Tests failed for ${EPYTHON}"
}
