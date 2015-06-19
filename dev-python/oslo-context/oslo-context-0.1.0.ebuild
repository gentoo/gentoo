# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/oslo-context/oslo-context-0.1.0.ebuild,v 1.1 2015/01/31 18:10:40 prometheanfire Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Helpers to maintain useful information about a request context"
HOMEPAGE="https://pypi.python.org/pypi/oslo.context"
SRC_URI="mirror://pypi/${PN:0:1}/oslo.context/oslo.context-${PV}.tar.gz"
S="${WORKDIR}/oslo.context-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		>=dev-python/pbr-0.8[${PYTHON_USEDEP}]
		<dev-python/pbr-1.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/hacking-0.9.2[${PYTHON_USEDEP}]
		<dev-python/hacking-0.10[${PYTHON_USEDEP}]
		>=dev-python/oslotest-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
		>=dev-python/oslo-sphinx-2.2.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.3.0[${PYTHON_USEDEP}]
	)"
RDEPEND="
	>=dev-python/Babel-1.3[${PYTHON_USEDEP}]
"

# This time half the doc files are missing; Do you want them?

python_test() {
	nosetests tests/ || die "test failed under ${EPYTHON}"
}
