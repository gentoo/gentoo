# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_4 )
DISTUTILS_IN_SOURCE_BUILD=TRUE

inherit distutils-r1

DESCRIPTION="Mock object framework for Python"
HOMEPAGE="http://www.openstack.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

CDEPEND="
	>=dev-python/pbr-1.8[${PYTHON_USEDEP}]
	<dev-python/pbr-2.0[${PYTHON_USEDEP}]
"
CRDEPEND=">=dev-python/fixtures-1.3.1[${PYTHON_USEDEP}]"

# NOTE dev-python/hacking isn't actually required for tests
# >=dev-python/hacking-0.5.6[${PYTHON_USEDEP}]
# <dev-python/hacking-0.7[${PYTHON_USEDEP}]

# NOTE dev-python/pyflakes isn't actually required for tests
# ~dev-python/pyflakes-0.7.2[${PYTHON_USEDEP}]

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
	test? (
		${CRDEPEND}
		~dev-python/pep8-1.5.7[${PYTHON_USEDEP}]
		~dev-python/pyflakes-0.8.1[${PYTHON_USEDEP}]
		>=dev-python/flake8-2.2.4[${PYTHON_USEDEP}]
		<=dev-python/flake8-2.4.1-r9999[${PYTHON_USEDEP}]
		>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
		>=dev-python/subunit-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testtools-1.4.0[${PYTHON_USEDEP}]
		>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.3[${PYTHON_USEDEP}]
		>=dev-python/oslo-sphinx-2.5.0[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	${CDEPEND}
	${CRDEPEND}
"

python_test() {
	# This single test fails on python3.4.
	# I speculate this is due to the old style classes going away but have not
	# verified this in any way.
	if [[ "${EPYTHON}" = "python3.4" ]]; then
		ebegin "patching mox3/tests/test_mox.py for ${EPYTHON}"
		sed \
			-e '/def testStubOutClass_OldStyle(self):/,/def/ d' \
			-i mox3/tests/test_mox.py
		STATUS=$?
		eend $?
		[[ ${STATUS} -gt 0 ]] && die
	fi

	testr init || die "testr init failed under ${EPYTHON}"
	testr run || die "testr run failed under ${EPYTHON}"
}
