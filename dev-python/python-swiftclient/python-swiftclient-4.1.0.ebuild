# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Python bindings to the OpenStack Object Storage API"
HOMEPAGE="https://launchpad.net/python-swiftclient"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

RDEPEND="
	>=dev-python/requests-2.4.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/pbr[${PYTHON_USEDEP}]
	test? (
		>=dev-python/keystoneauth-3.4.0[${PYTHON_USEDEP}]
		dev-python/python-keystoneclient[${PYTHON_USEDEP}]
		>=dev-python/mock-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/openstacksdk-0.11.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

python_prepare_all() {
	sed -e 's/test_password_prompt/_&/' -i test/unit/test_shell.py || die
	# fix duplicate script/entry point
	# https://bugs.launchpad.net/python-swiftclient/+bug/1975361
	sed -i -e '/bin\/swift/d' setup.cfg || die
	distutils-r1_python_prepare_all
}
