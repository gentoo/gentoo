# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="HTTP client mock for Python"
HOMEPAGE="
	https://github.com/gabrielfalcao/httpretty/
	https://pypi.org/project/httpretty/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv sparc x86"
IUSE="test-rust"

RDEPEND="
	dev-python/urllib3[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/freezegun[${PYTHON_USEDEP}]
		>=dev-python/requests-1.1[${PYTHON_USEDEP}]
		dev-python/sure[${PYTHON_USEDEP}]
		>=dev-python/tornado-2.2[${PYTHON_USEDEP}]
	)
"
# These are optional test deps, that are used to test compatibility
# with various HTTP libs.  We prefer pulling them in whenever possible
# to increase test coverage but we can live without them.
# We're skipping redis entirely since it requires a running server.
BDEPEND+="
	test? (
		test-rust? (
			dev-python/pyopenssl[${PYTHON_USEDEP}]
		)
		$(python_gen_cond_dep '
			>=dev-python/boto3-1.17.72[${PYTHON_USEDEP}]
			dev-python/httplib2[${PYTHON_USEDEP}]
			>=dev-python/httpx-0.18.1[${PYTHON_USEDEP}]
		' python3_{8..11})
		$(python_gen_cond_dep '
			>=dev-python/eventlet-0.25.1[${PYTHON_USEDEP}]
		' python3_{8..9})
	)
"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}/${P}-pytest.patch"
)

python_test() {
	local EPYTEST_IGNORE=(
		# this seems to be a stress test
		tests/bugfixes/pytest/test_426_mypy_segfault.py
		# passthrough tests require Internet access
		tests/functional/test_passthrough.py
	)

	local ignore_by_dep=(
		dev-python/boto3:tests/bugfixes/nosetests/test_416_boto3.py
		dev-python/eventlet:tests/bugfixes/nosetests/test_eventlet.py
		dev-python/httplib2:tests/functional/test_httplib2.py
		dev-python/httpx:tests/bugfixes/nosetests/test_414_httpx.py
		dev-python/pyopenssl:tests/bugfixes/nosetests/test_417_openssl.py
	)

	local x
	for x in "${ignore_by_dep[@]}"; do
		if ! has_version "${x%:*}[${PYTHON_USEDEP}]"; then
			EPYTEST_IGNORE+=( "${x#*:}" )
		fi
	done

	epytest
}
