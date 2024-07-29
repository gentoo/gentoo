# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="HTTP client mock for Python"
HOMEPAGE="
	https://github.com/gabrielfalcao/httpretty/
	https://pypi.org/project/httpretty/
"

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
		>=dev-python/boto3-1.17.72[${PYTHON_USEDEP}]
		dev-python/httplib2[${PYTHON_USEDEP}]
		>=dev-python/httpx-0.18.1[${PYTHON_USEDEP}]
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
		# eventlet is masked for removal
		tests/bugfixes/nosetests/test_eventlet.py
	)
	local EPYTEST_DESELECT=(
		# regressions with newer dev-python/requests
		tests/functional/test_requests.py::test_httpretty_should_allow_registering_regexes_with_streaming_responses
		tests/functional/test_requests.py::test_httpretty_should_handle_paths_starting_with_two_slashes
	)

	local ignore_by_dep=(
		dev-python/boto3:tests/bugfixes/nosetests/test_416_boto3.py
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
