# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pbr
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Python bindings for the Ironic API"
HOMEPAGE="
	https://opendev.org/openstack/python-ironicclient/
	https://github.com/openstack/python-ironicclient/
	https://pypi.org/project/python-ironicclient/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

RDEPEND="
	>=dev-python/pbr-6.0.0[${PYTHON_USEDEP}]
	>=dev-python/cliff-2.8.0[${PYTHON_USEDEP}]
	>=dev-python/dogpile-cache-0.8.0[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-3.2.0[${PYTHON_USEDEP}]
	>=dev-python/keystoneauth1-3.11.0[${PYTHON_USEDEP}]
	>=dev-python/openstacksdk-0.18.0[${PYTHON_USEDEP}]
	>=dev-python/osc-lib-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.33.0[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-3[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.13.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.14.2[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.20.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/requests-mock-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/oslotest-3.2.0[${PYTHON_USEDEP}]
		>=dev-python/testtools-2.2.0[${PYTHON_USEDEP}]
		>=dev-python/tempest-17.1.0[${PYTHON_USEDEP}]
		>=dev-python/ddt-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/python-openstackclient-3.12.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest
