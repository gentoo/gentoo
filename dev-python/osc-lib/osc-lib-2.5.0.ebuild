# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="A package of common support modules for writing OSC plugins"
HOMEPAGE="https://github.com/openstack/osc-lib"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/cliff-3.2.0[${PYTHON_USEDEP}]
	>=dev-python/keystoneauth-3.14.0[${PYTHON_USEDEP}]
	>=dev-python/openstacksdk-0.15.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-3.15.3[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.33.0[${PYTHON_USEDEP}]
	>=dev-python/simplejson-3.5.1[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.20.0[${PYTHON_USEDEP}]
"
BDEPEND="
	>dev-python/pbr-2.1.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/oslotest-3.2.0[${PYTHON_USEDEP}]
		>=dev-python/requests-mock-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/statsd-3.3.0[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		>=dev-python/testtools-2.2.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

src_prepare() {
	# need to skip all tests under TestTagHelps class
	# checks exact help message, based on another unittest runner
	sed -e '179,$s/test_add_tag_/_&/' -i osc_lib/tests/utils/test_tags.py || die
	distutils-r1_src_prepare
}
