# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} pypy3 )

inherit distutils-r1

DESCRIPTION="Attributes without boilerplate"
HOMEPAGE="
	https://github.com/python-attrs/attrs/
	https://attrs.readthedocs.io/
	https://pypi.org/project/attrs/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/zope-interface[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		$(python_gen_impl_dep sqlite)
		$(python_gen_cond_dep '
			dev-python/cloudpickle[${PYTHON_USEDEP}]
		' 'python*')
		>=dev-python/hypothesis-3.6.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-4.3.0[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_IGNORE=()
	[[ ${EPYTHON} != python* ]] && EPYTEST_IGNORE+=(
		# requires cloudpickle which relies on CPython implementation
		# details
		tests/test_3rd_party.py
	)

	epytest
}
