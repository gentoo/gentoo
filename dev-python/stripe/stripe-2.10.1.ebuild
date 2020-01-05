# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} pypy3 )
inherit distutils-r1

DESCRIPTION="Stripe python bindings"
HOMEPAGE="https://github.com/stripe/stripe-python"
SRC_URI="mirror://pypi/s/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	$(python_gen_cond_dep '>=dev-python/requests-2[${PYTHON_USEDEP}]' 'python3*' pypy3)
	$(python_gen_cond_dep '>=dev-python/requests-2[ssl,${PYTHON_USEDEP}]' 'python2*' pypy)
"
# See https://github.com/stripe/stripe-python/blob/v2.10.1/tests/conftest.py#L17
# for minimum required version of stripe-mock
# Running the tests against dev-util/stripe-mock-0.47.0 resulted in test errors
DEPEND="${RDEPEND}
	test? (
		>=dev-util/stripe-mock-0.33.0
		<dev-util/stripe-mock-0.47.0
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		net-misc/curl
	)
"

DOCS=(LONG_DESCRIPTION.rst CHANGELOG.md README.md)

src_test() {
	local stripe_mock_port=12111
	local stripe_mock_max_port=12121
	local stripe_mock_logfile="${T}/stripe_mock_${EPYTHON}.log"
	# Try to start stripe-mock until we find a free port
	while [[ "${stripe_mock_port}" -le "${stripe_mock_max_port}" ]]; do
		ebegin "Trying to start stripe-mock on port ${stripe_mock_port}"
		stripe-mock --http-port ${stripe_mock_port} &> "${stripe_mock_logfile}" &
		local stripe_mock_pid=$!
		sleep 2
		# Did stripe-mock start?
		curl --fail -u "sk_test_123:" \
			http://127.0.0.1:${stripe_mock_port}/v1/customers &> /dev/null
		eend $? "Port ${stripe_mock_port} unavailable"
		if [[ $? -eq 0 ]]; then
			einfo "stripe-mock running on port ${stripe_mock_port}"
			break
		fi
		(( stripe_mock_port++ ))
	done
	if [[ "${stripe_mock_port}" -gt "${stripe_mock_max_port}" ]]; then
		eerror "Unable to start stripe-mock for tests"
		die "Please see the logfile located at: ${stripe_mock_logfile}"
	fi

	distutils-r1_src_test

	# Tear down stripe-mock
	kill "${stripe_mock_pid}" || die "Unable to stop stripe-mock"
}

python_test() {
	STRIPE_MOCK_PORT=${stripe_mock_port} pytest -vv || die "Tests failed with ${EPYTHON}"
}
