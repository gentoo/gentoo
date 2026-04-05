# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pbr
PYPI_PN=${PN/-/.}
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="OpenStack logging config library, configuration for all openstack projects"
HOMEPAGE="
	https://opendev.org/openstack/oslo.log/
	https://github.com/openstack/oslo.log/
	https://pypi.org/project/oslo.log/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"

RDEPEND="
	>=dev-python/debtcollector-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/pbr-3.2.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-5.2.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-context-2.20.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-3.20.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-7.1.0-r1[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.25.0[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.7.0[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/pbr-3.1.1[${PYTHON_USEDEP}]
	test? (
		>=dev-python/testtools-2.3.0[${PYTHON_USEDEP}]
		>=dev-python/oslotest-3.3.0[${PYTHON_USEDEP}]
		>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

src_test() {
	# requires eventlet
	rm oslo_log/tests/unit/test_pipe_mutex.py || die
	# suddenly started failing on py3.13 (also in old version)
	sed -i -e 's:test_rate_limit:_&:' \
		oslo_log/tests/unit/test_rate_limit.py || die

	distutils-r1_src_test
}
