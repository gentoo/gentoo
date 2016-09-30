# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5}} )

inherit distutils-r1 vcs-snapshot

MY_PN=${PN/-/.}

DESCRIPTION="Oslo Serialization library"
HOMEPAGE="https://launchpad.net/oslo"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc test"

CDEPEND=">=dev-python/pbr-1.8[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
	test? (
		>=dev-python/mock-1.2[${PYTHON_USEDEP}]
		virtual/python-ipaddress[${PYTHON_USEDEP}]
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/netaddr-0.7.12[${PYTHON_USEDEP}]
		!~dev-python/netaddr-0.7.16[${PYTHON_USEDEP}]
		>=dev-python/oslo-i18n-2.1.0[${PYTHON_USEDEP}]
		>=dev-python/oslotest-1.10.0[${PYTHON_USEDEP}]
	)
	doc? (
		>=dev-python/oslo-sphinx-2.5.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.3[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	${CDEPEND}
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/msgpack-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.16.0[${PYTHON_USEDEP}]
	>=dev-python/pytz-2013.6[${PYTHON_USEDEP}]
"

python_prepare_all() {
	use doc && esetup.py build_sphinx
}

# Note: Tests fail due to requiring installation.
#
# Installation appears to fail due ot the use of namespace packages but root
# cause was never truly established.
RESTRICT="test"

python_test() {
	distutils_install_for_testing

	PYTHONPATH="${TEST_DIR}/lib:${PYTHONPATH}"

	rm -rf .testrepository || die "couldn't remove '.testrepository' under ${EPTYHON}"

	testr init || die "testr init failed under ${EPYTHON}"
	testr run || die "testr run failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/build/html/. )

	distutils-r1_python_install_all
}
