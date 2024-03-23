# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 8 -- sys-apps/portage dep
EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_TESTED=( python3_{10..12} pypy3 )
PYTHON_COMPAT=( "${PYTHON_TESTED[@]}" )
PYTHON_REQ_USE="ssl(+)"

inherit distutils-r1 pypi

# The package has a test dependency on their own hypercorn fork.
HYPERCORN_COMMIT=d1719f8c1570cbd8e6a3719ffdb14a4d72880abb
DESCRIPTION="HTTP library with thread-safe connection pooling, file post, and more"
HOMEPAGE="
	https://github.com/urllib3/urllib3/
	https://pypi.org/project/urllib3/
"
SRC_URI+="
	test? (
		https://github.com/urllib3/hypercorn/archive/${HYPERCORN_COMMIT}.tar.gz
			-> hypercorn-${HYPERCORN_COMMIT}.gh.tar.gz
	)
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="brotli http2 test zstd"
RESTRICT="!test? ( test )"

# [secure] extra is deprecated and slated for removal, we don't need it:
# https://github.com/urllib3/urllib3/issues/2680
RDEPEND="
	>=dev-python/PySocks-1.5.8[${PYTHON_USEDEP}]
	<dev-python/PySocks-2.0[${PYTHON_USEDEP}]
	brotli? ( >=dev-python/brotlicffi-0.8.0[${PYTHON_USEDEP}] )
	http2? (
		<dev-python/h2-5[${PYTHON_USEDEP}]
		>=dev-python/h2-4[${PYTHON_USEDEP}]
	)
	zstd? ( >=dev-python/zstandard-0.18.0[${PYTHON_USEDEP}] )
"
BDEPEND="
	test? (
		$(python_gen_cond_dep "
			${RDEPEND}
			dev-python/brotlicffi[\${PYTHON_USEDEP}]
			dev-python/freezegun[\${PYTHON_USEDEP}]
			dev-python/h2[\${PYTHON_USEDEP}]
			dev-python/httpx[\${PYTHON_USEDEP}]
			dev-python/pytest[\${PYTHON_USEDEP}]
			dev-python/pytest-rerunfailures[\${PYTHON_USEDEP}]
			dev-python/pytest-timeout[\${PYTHON_USEDEP}]
			dev-python/pytest-xdist[\${PYTHON_USEDEP}]
			dev-python/quart[\${PYTHON_USEDEP}]
			dev-python/quart-trio[\${PYTHON_USEDEP}]
			dev-python/trio[\${PYTHON_USEDEP}]
			>=dev-python/tornado-4.2.1[\${PYTHON_USEDEP}]
			>=dev-python/trustme-0.5.3[\${PYTHON_USEDEP}]
			>=dev-python/zstandard-0.18.0[\${PYTHON_USEDEP}]
		" "${PYTHON_TESTED[@]}")
	)
"

src_prepare() {
	# upstream considers 0.5 s to be "long" for a timeout
	# we get tons of test failures on *fast* systems because of that
	sed -i -e '/LONG_TIMEOUT/s:0.5:5:' test/__init__.py || die
	distutils-r1_src_prepare
}

python_test() {
	local -x PYTHONPATH=${WORKDIR}/hypercorn-${HYPERCORN_COMMIT}/src
	local -x CI=1
	if ! has "${EPYTHON}" "${PYTHON_TESTED[@]/_/.}"; then
		einfo "Skipping tests on ${EPYTHON}"
		return
	fi

	local EPYTEST_DESELECT=(
		# TODO: timeouts
		test/contrib/test_pyopenssl.py::TestSocketClosing::test_timeout_errors_cause_retries
		test/with_dummyserver/test_socketlevel.py::TestSocketClosing::test_timeout_errors_cause_retries
		# TODO: random regression?
		test/contrib/test_socks.py::TestSocks5Proxy::test_socket_timeout
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local EPYTEST_XDIST=1
	epytest -p timeout -p rerunfailures --reruns=10 --reruns-delay=2
}
