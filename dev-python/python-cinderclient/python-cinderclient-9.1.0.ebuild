# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="A client for the OpenStack Cinder API"
HOMEPAGE="https://launchpad.net/python-cinderclient"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~riscv x86"

RDEPEND="
	>=dev-python/keystoneauth1-4.3.1[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-5.0.1[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-4.8.0[${PYTHON_USEDEP}]
	>=dev-python/pbr-5.5.0[${PYTHON_USEDEP}]
	>=dev-python/prettytable-0.7.2[${PYTHON_USEDEP}]
	>=dev-python/requests-2.25.1[${PYTHON_USEDEP}]
	>=dev-python/simplejson-3.5.1[${PYTHON_USEDEP}]
	>=dev-python/stevedore-3.3.0[${PYTHON_USEDEP}]
"
# Tests fail with dev-python/prettytable-3.4.0
BDEPEND="
	dev-python/pbr[${PYTHON_USEDEP}]
	test? (
		dev-python/ddt[${PYTHON_USEDEP}]
		dev-python/fixtures[${PYTHON_USEDEP}]
		dev-python/oslo-serialization[${PYTHON_USEDEP}]
		dev-python/requests-mock[${PYTHON_USEDEP}]
		dev-python/testtools[${PYTHON_USEDEP}]
		<dev-python/prettytable-3.4.0[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${P}-fix-py3.11-argparse.patch"
	"${FILESDIR}/${P}-fix-py3.11-crashes.patch"
)

distutils_enable_tests unittest

python_test() {
	# functional tests require cloud instance access
	eunittest -b cinderclient/tests/unit
}
