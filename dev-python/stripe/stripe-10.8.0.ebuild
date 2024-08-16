# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Stripe Python bindings"
HOMEPAGE="
	https://github.com/stripe/stripe-python/
	https://pypi.org/project/stripe/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="telemetry"

RDEPEND="
	>=dev-python/requests-2.20[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.5.0[${PYTHON_USEDEP}]
"
# please bump dev-util/stripe-mock dep to the latest version on every bump
BDEPEND="
	test? (
		>=dev-util/stripe-mock-0.188.0
		dev-python/aiohttp[${PYTHON_USEDEP}]
		dev-python/anyio[${PYTHON_USEDEP}]
		dev-python/httpx[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/trio[${PYTHON_USEDEP}]
		net-misc/curl
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

DOCS=( LONG_DESCRIPTION.rst CHANGELOG.md README.md )

src_prepare() {
	distutils-r1_src_prepare

	if ! use telemetry; then
		sed -i -e '/enable_telemetry/s:True:False:' stripe/__init__.py || die
	fi
}

python_test() {
	local EPYTEST_DESELECT=(
		# exception message mismatch with aiohttp-3.10.0
		"tests/test_integration.py::TestIntegration::test_async_timeout[asyncio-aiohttp]"
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest tests -p anyio -p pytest_mock
}

src_test() {
	local stripe_mock_port=12111
	local stripe_mock_max_port=12121
	local stripe_mock_logfile="${T}/stripe_mock_${EPYTHON}.log"
	# Try to start stripe-mock until we find a free port
	while [[ ${stripe_mock_port} -le ${stripe_mock_max_port} ]]; do
		ebegin "Trying to start stripe-mock on port ${stripe_mock_port}"
		stripe-mock --http-port "${stripe_mock_port}" &> "${stripe_mock_logfile}" &
		local stripe_mock_pid=${!}
		sleep 2
		# Did stripe-mock start?
		curl --fail -u "sk_test_123:" \
			"http://127.0.0.1:${stripe_mock_port}/v1/customers" &> /dev/null
		eend ${?} "Port ${stripe_mock_port} unavailable"
		if [[ ${?} -eq 0 ]]; then
			einfo "stripe-mock running on port ${stripe_mock_port}"
			break
		fi
		(( stripe_mock_port++ ))
	done
	if [[ ${stripe_mock_port} -gt ${stripe_mock_max_port} ]]; then
		eerror "Unable to start stripe-mock for tests"
		die "Please see the logfile located at: ${stripe_mock_logfile}"
	fi

	local -x STRIPE_MOCK_PORT=${stripe_mock_port}
	distutils-r1_src_test

	# Tear down stripe-mock
	kill "${stripe_mock_pid}" || die "Unable to stop stripe-mock"
}
