# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_3 python3_4)

inherit distutils-r1

DESCRIPTION="The Oslo Policy library provides support for RBAC policy enforcement across all OpenStack services."
HOMEPAGE="https://pypi.python.org/pypi/oslo.policy"
SRC_URI="mirror://pypi/${PN:0:1}/oslo.policy/oslo.policy-${PV}.tar.gz"
S="${WORKDIR}/oslo.policy-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		>=dev-python/pbr-0.8[${PYTHON_USEDEP}]
		<dev-python/pbr-1.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/hacking-0.10[${PYTHON_USEDEP}]
		<dev-python/hacking-0.11[${PYTHON_USEDEP}]
		>=dev-python/oslotest-1.5.1[${PYTHON_USEDEP}]
		>=dev-python/oslo-sphinx-2.5.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.3.0[${PYTHON_USEDEP}]
	)"
RDEPEND="
	>=dev-python/oslo-config-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.2.0[${PYTHON_USEDEP}]
"

# This time half the doc files are missing; Do you want them?

python_test() {
	nosetests tests/ || die "test failed under ${EPYTHON}"
}
