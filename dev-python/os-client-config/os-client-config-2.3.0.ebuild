# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="OpenStack Client Configuation Library"
HOMEPAGE="
	https://opendev.org/openstack/os-client-config/
	https://github.com/openstack/os-client-config/
	https://pypi.org/project/os-client-config/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"

RDEPEND="
	>dev-python/pbr-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/openstacksdk-0.13.0[${PYTHON_USEDEP}]
"
BDEPEND="
	>dev-python/pbr-2.1.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/jsonschema-3.2.0[${PYTHON_USEDEP}]
		>=dev-python/prometheus-client-0.4.2[${PYTHON_USEDEP}]
		dev-python/python-glanceclient[${PYTHON_USEDEP}]
		>=dev-python/oslo-config-6.1.0[${PYTHON_USEDEP}]
		>=dev-python/oslotest-3.2.0[${PYTHON_USEDEP}]
		dev-python/python-subunit[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		>=dev-python/testtools-2.2.0[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/test_get_all_clouds.patch
)

distutils_enable_tests unittest
