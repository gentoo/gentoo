# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_{6,7,8,9}} pypy3 )

inherit distutils-r1

DESCRIPTION="A utility belt for advanced users of python-requests"
HOMEPAGE="https://toolbelt.readthedocs.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="test"

RDEPEND="<dev-python/requests-3.0.0[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? (
		dev-python/betamax[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)"

DOCS=( AUTHORS.rst HISTORY.rst README.rst )

PATCHES=(
	"${FILESDIR}/requests-toolbelt-0.8.0-test-tracebacks.patch"
	"${FILESDIR}/requests-toolbelt-0.9.1-tests.patch"

	# disable python2.7 test failures with newer requests versions
	# bug: https://bugs.gentoo.org/635824
	# https://github.com/requests/toolbelt/issues/213
	"${FILESDIR}/requests-toolbelt-0.9.1-tests-py2.patch"

	# disable tests that require internet access
	"${FILESDIR}/requests-toolbelt-0.9.1-tests-internet.patch"
)

distutils_enable_tests pytest
