# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1 vcs-snapshot

MY_PN=${PN/-/.}

DESCRIPTION="Oslo Configuration API"
HOMEPAGE="https://launchpad.net/oslo"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

CDEPEND=">=dev-python/pbr-1.3[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
	test? (
		>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		>=dev-python/testtools-2.2.0[${PYTHON_USEDEP}]
		>=dev-python/oslotest-3.2.0[${PYTHON_USEDEP}]
		>=dev-python/oslo-log-3.36.0[${PYTHON_USEDEP}]
		>=dev-python/coverage-4.0[${PYTHON_USEDEP}]
		!~dev-python/coverage-4.4[${PYTHON_USEDEP}]
		>=dev-python/reno-2.5.0[${PYTHON_USEDEP}]
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/requests-mock-1.5.0[${PYTHON_USEDEP}]
		>=dev-python/bandit-1.1.0[${PYTHON_USEDEP}]
	)
	doc? (
		>=dev-python/sphinx-1.6.2[${PYTHON_USEDEP}]
		!~dev-python/sphinx-1.6.6[${PYTHON_USEDEP}]
		!~dev-python/sphinx-1.6.7[${PYTHON_USEDEP}]
		>=dev-python/reno-2.5.0[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	${CDEPEND}
	>=dev-python/debtcollector-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/netaddr-0.7.18[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.20.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-3.15.3[${PYTHON_USEDEP}]
	>=dev-python/rfc3986-0.3.1[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.12.0[${PYTHON_USEDEP}]
	virtual/python-enum34[${PYTHON_USEDEP}]
	>=dev-python/requests-2.18.0[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -i '/^hacking/d' test-requirements.txt || die
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
