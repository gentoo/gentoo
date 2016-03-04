# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_{3,4,5}} )

inherit distutils-r1

DESCRIPTION="Client Library for OpenStack Identity"
HOMEPAGE="http://www.openstack.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"

# Note: blacklist version not in portage:
#doc? ( !~dev-python/sphinx-1.3_preb1[${PYTHON_USEDEP}] )

CDEPEND="
	>=dev-python/pbr-1.6[${PYTHON_USEDEP}]"
TCDEPEND="
	>=dev-python/lxml-2.3[${PYTHON_USEDEP}]
	>=dev-python/mock-1.2[${PYTHON_USEDEP}]
	>=dev-python/requests-mock-0.6.0[${PYTHON_USEDEP}]
	>=dev-python/tempest-lib-0.8.0[${PYTHON_USEDEP}]
	>=dev-python/testresources-0.2.4[${PYTHON_USEDEP}]
	>=dev-python/webob-1.2.3[${PYTHON_USEDEP}]
	>=dev-python/bandit-0.13.2[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
	test? (
		${TCDEPEND}
		>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
		>=dev-python/keyring-2.1[${PYTHON_USEDEP}]
		!~dev-python/keyring-3.3[${PYTHON_USEDEP}]
		>=dev-python/oauthlib-0.6[${PYTHON_USEDEP}]
		>=dev-python/oslotest-1.10.0[${PYTHON_USEDEP}]
		>=dev-python/pycrypto-2.6[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testtools-1.4.0[${PYTHON_USEDEP}]
	)
	doc? (
		${TCDEPEND}
		>=dev-python/fixtures-1.3.1[${PYTHON_USEDEP}]
		>=dev-python/oslo-sphinx-2.5.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.3[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	${CDEPEND}
	>=dev-python/Babel-1.3[${PYTHON_USEDEP}]
	>=dev-python/iso8601-0.1.9[${PYTHON_USEDEP}]
	>=dev-python/debtcollector-0.3.0[${PYTHON_USEDEP}]
	>=dev-python/netaddr-0.7.12[${PYTHON_USEDEP}]
	!~dev-python/netaddr-0.7.16[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-2.3.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-utils-2.6.0[${PYTHON_USEDEP}]
	>=dev-python/prettytable-0.7[${PYTHON_USEDEP}]
	<dev-python/prettytable-0.8[${PYTHON_USEDEP}]
	>=dev-python/requests-2.5.2[${PYTHON_USEDEP}]
	!~dev-python/requests-2.8.0[${PYTHON_USEDEP}]
	!~dev-python/requests-2.9.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.5.0[${PYTHON_USEDEP}]
"
PATCHES=(
)

python_prepare_all() {
	use doc && esetup.py build_sphinx
	sed -i '/^argparse/d' requirements.txt || die
	sed -i '/^hacking/d' test-requirements.txt || die
	distutils-r1_python_prepare_all
}

python_test() {
	rm -rf .testrepository || die "couldn't remove '.testrepository' under ${EPYTHON}"

	testr init || die "testr init failed under ${EPYTHON}"
	testr run || die "testr run failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/build/html/. )
	use examples && local EXAMPLES=( examples/. )

	distutils-r1_python_install_all
}
