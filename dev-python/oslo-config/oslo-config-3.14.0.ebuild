# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5}} )

inherit distutils-r1 vcs-snapshot

MY_PN=${PN/-/.}

DESCRIPTION="Oslo Configuration API"
HOMEPAGE="https://launchpad.net/oslo"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"

CDEPEND=">=dev-python/pbr-1.3[${PYTHON_USEDEP}]"
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
		>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
		>=dev-python/reno-1.8.0[${PYTHON_USEDEP}]
		>=dev-python/mock-2.0[${PYTHON_USEDEP}]
		>=dev-python/bandit-1.0.1[${PYTHON_USEDEP}]
	)
	doc? (
		>=dev-python/oslo-sphinx-2.5.0[${PYTHON_USEDEP}]
		!~dev-python/oslo-sphinx-3.4.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.3[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	${CDEPEND}
	>=dev-python/debtcollector-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/netaddr-0.7.12[${PYTHON_USEDEP}]
	!~dev-python/netaddr-0.7.16[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.16.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/rfc3986-0.2.0[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -i '/^hacking/d' test-requirements.txt || die
	sed -i '/^argparse/d' requirements.txt || die
	use doc && esetup.py build_sphinx
	distutils-r1_python_prepare_all
}

python_test() {
	rm -rf .testrepository || die "could not remove '.testrepository' under ${EPTYHON}"

	testr init || die "testr init failed under ${EPYTHON}"
	testr run || die "testr run failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/build/html/. )

	distutils-r1_python_install_all
}
