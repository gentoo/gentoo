# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

DESCRIPTION="Stripe python bindings"
HOMEPAGE="https://github.com/stripe/stripe-python"
SRC_URI="mirror://pypi/s/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/requests-2.20[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-util/stripe-mock-0.115.0
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		net-misc/curl
	)
"

distutils_enable_tests pytest

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

	local -x STRIPE_MOCK_PORT=${stripe_mock_port}
	distutils-r1_src_test

	# Tear down stripe-mock
	kill "${stripe_mock_pid}" || die "Unable to stop stripe-mock"
}
