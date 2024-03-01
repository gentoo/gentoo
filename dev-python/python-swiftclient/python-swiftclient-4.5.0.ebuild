# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 pypi

DESCRIPTION="Python bindings to the OpenStack Object Storage API"
HOMEPAGE="
	https://opendev.org/openstack/python-swiftclient/
	https://github.com/openstack/python-swiftclient/
	https://pypi.org/project/python-swiftclient/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/requests-2.4.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/pbr[${PYTHON_USEDEP}]
	test? (
		>=dev-python/keystoneauth1-3.4.0[${PYTHON_USEDEP}]
		>=dev-python/openstacksdk-0.11.0[${PYTHON_USEDEP}]
		>=dev-python/python-keystoneclient-0.7.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

python_prepare_all() {
	sed -e 's/test_password_prompt/_&/' -i test/unit/test_shell.py || die
	distutils-r1_python_prepare_all
}
