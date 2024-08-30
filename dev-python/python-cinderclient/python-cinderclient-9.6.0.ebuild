# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="A client for the OpenStack Cinder API"
HOMEPAGE="
	https://opendev.org/openstack/python-cinderclient/
	https://github.com/openstack/python-cinderclient/
	https://pypi.org/project/python-cinderclient/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

RDEPEND="
	>=dev-python/keystoneauth1-4.3.1[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-5.0.1[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-4.8.0[${PYTHON_USEDEP}]
	>=dev-python/pbr-5.5.0[${PYTHON_USEDEP}]
	>=dev-python/prettytable-0.7.2[${PYTHON_USEDEP}]
	>=dev-python/requests-2.25.1[${PYTHON_USEDEP}]
	>=dev-python/stevedore-3.3.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/pbr[${PYTHON_USEDEP}]
	test? (
		dev-python/ddt[${PYTHON_USEDEP}]
		dev-python/fixtures[${PYTHON_USEDEP}]
		dev-python/oslo-serialization[${PYTHON_USEDEP}]
		dev-python/requests-mock[${PYTHON_USEDEP}]
		dev-python/testtools[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

python_test() {
	# functional tests require cloud instance access
	eunittest -b cinderclient/tests/unit
}
