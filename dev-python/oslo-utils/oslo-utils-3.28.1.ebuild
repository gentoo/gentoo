# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1 vcs-snapshot

MY_PN=${PN/-/.}

DESCRIPTION="Oslo Utility library"
HOMEPAGE="https://launchpad.net/oslo"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc test"

CDEPEND=">=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
	test? (
		>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/subunit-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		>=dev-python/testtools-1.4.0[${PYTHON_USEDEP}]
		>=dev-python/oslotest-1.10.0[${PYTHON_USEDEP}]
		>=dev-python/coverage-4.0.0[${PYTHON_USEDEP}]
		!~dev-python/coverage-4.4.0[${PYTHON_USEDEP}]
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/oslo-config-4.0.0[${PYTHON_USEDEP}]
		!~dev-python/oslo-config-4.3.0[${PYTHON_USEDEP}]
		!~dev-python/oslo-config-4.4.0[${PYTHON_USEDEP}]
		>=dev-python/bandit-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/reno-1.8.0[${PYTHON_USEDEP}]
	)
	doc? (
		>=dev-python/sphinx-1.6.2[${PYTHON_USEDEP}]
		>=dev-python/openstackdocstheme-1.16.0[${PYTHON_USEDEP}]
		>=dev-python/reno-1.8.0[${PYTHON_USEDEP}]
		!~dev-python/reno-2.3.1[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	${CDEPEND}
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	virtual/python-funcsigs[${PYTHON_USEDEP}]
	>=dev-python/iso8601-0.1.11[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-2.1.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-i18n-3.15.2[${PYTHON_USEDEP}]
	>=dev-python/monotonic-0.6[${PYTHON_USEDEP}]
	>=dev-python/pytz-2013.6[${PYTHON_USEDEP}]
	>=dev-python/netaddr-0.7.13[${PYTHON_USEDEP}]
	!~dev-python/netaddr-0.7.16[${PYTHON_USEDEP}]
	>=dev-python/netifaces-0.10.4[${PYTHON_USEDEP}]
	>=dev-python/debtcollector-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-2.1.0[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -i '/^hacking/d' test-requirements.txt || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && esetup.py build_sphinx
}

# Note: Tests fail due to requiring installation
#
# Installation appears to fail due to the use of namespace packages but root
# cause was never truly established.
#
# Tests fail with:
# ImportError: No module named 'oslo.utils

#RESTRICT="test"

python_test() {
	distutils_install_for_testing

	cd "${TEST_DIR}"/lib || die

	rm -rf .testrepository || die "couldn't remove '.testrepository' under ${EPTYHON}"

	testr init || die "testr init failed under ${EPYTHON}"
	testr run || die "testr run failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/build/html/. )

	distutils-r1_python_install_all
}
