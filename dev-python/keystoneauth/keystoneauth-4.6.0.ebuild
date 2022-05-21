# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="This package contains tools for authenticating to an OpenStack-based cloud"
HOMEPAGE="https://github.com/openstack/keystoneauth"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}1/${PN}1-${PV}.tar.gz"
S="${WORKDIR}/${PN}1-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

CDEPEND="
	>dev-python/pbr-2.1.0[${PYTHON_USEDEP}]
"
RDEPEND="
	${CDEPEND}
	>=dev-python/iso8601-0.1.11[${PYTHON_USEDEP}]
	>=dev-python/requests-2.14.2[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.20.0[${PYTHON_USEDEP}]
	>=dev-python/os-service-types-1.2.0[${PYTHON_USEDEP}]
"
BDEPEND="
	${CDEPEND}
	test? (
		>=dev-python/betamax-0.7.0[${PYTHON_USEDEP}]
		>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/lxml-4.2.0[${PYTHON_USEDEP}]
		>=dev-python/oauthlib-0.6.2[${PYTHON_USEDEP}]
		>=dev-python/oslo-config-5.2.0[${PYTHON_USEDEP}]
		>=dev-python/oslo-utils-3.33.0[${PYTHON_USEDEP}]
		>=dev-python/oslotest-3.2.0[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-3.12[${PYTHON_USEDEP}]
		>=dev-python/requests-kerberos-0.8.0[${PYTHON_USEDEP}]
		>=dev-python/requests-mock-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/testresources-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/testtools-2.2.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

src_prepare() {
	# relies on specific test runner name
	sed -i -e 's:run\.py:unittest_or_fail.py:' \
		keystoneauth1/tests/unit/test_session.py || die
	# remove the test that requires hacking
	rm keystoneauth1/tests/unit/test_hacking_checks.py || die
	distutils-r1_src_prepare
}

python_test() {
	eunittest -b
}
