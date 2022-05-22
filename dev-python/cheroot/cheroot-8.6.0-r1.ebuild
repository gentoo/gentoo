# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} pypy3 )

inherit distutils-r1

DESCRIPTION="High-performance, pure-Python HTTP server used by CherryPy"
HOMEPAGE="
	https://www.cherrypy.org/
	https://pypi.org/project/cheroot/
	https://github.com/cherrypy/cheroot/
"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="
	>=dev-python/six-1.11.0[${PYTHON_USEDEP}]
	>=dev-python/more-itertools-2.6[${PYTHON_USEDEP}]
	dev-python/jaraco-functools[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/jaraco-context[${PYTHON_USEDEP}]
		dev-python/jaraco-text[${PYTHON_USEDEP}]
		dev-python/portend[${PYTHON_USEDEP}]
		dev-python/pytest-forked[${PYTHON_USEDEP}]
		>=dev-python/pytest-mock-1.11.0[${PYTHON_USEDEP}]
		dev-python/requests-toolbelt[${PYTHON_USEDEP}]
		dev-python/requests-unixsocket[${PYTHON_USEDEP}]
		dev-python/urllib3[${PYTHON_USEDEP}]
		!ia64? (
			dev-python/pyopenssl[${PYTHON_USEDEP}]
			dev-python/trustme[${PYTHON_USEDEP}]
		)
	)
"

PATCHES=(
	# Bad dep (upstream gone, only PyPi package, has py2 code, etc)
	"${FILESDIR}/${PN}-8.6.0-remove-pypytools-dep.patch"
)

distutils_enable_tests pytest

python_prepare_all() {
	sed -e '/--cov/d' \
		-e '/--testmon/d' \
		-e '/--numproc/d' \
		-i pytest.ini || die

	# broken
	sed -e '/False.*localhost/d' \
		-i cheroot/test/test_ssl.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	local EPYTEST_IGNORE=()
	if ! has_version "dev-python/pyopenssl[${PYTHON_USEDEP}]" ||
		! has_version "dev-python/trustme[${PYTHON_USEDEP}]"
	then
		EPYTEST_IGNORE+=(
			lib/cheroot/test/test_ssl.py
		)
	fi

	epytest
}
