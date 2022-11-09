# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Pure-Python implementation of the AMQP"
HOMEPAGE="
	https://pika.readthedocs.io/
	https://github.com/pika/pika/
	https://pypi.org/project/pika/
"
SRC_URI="https://github.com/pika/pika/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"
RESTRICT="test !test? ( test )"
PROPERTIES="test_network"

BDEPEND="
	test? (
		dev-python/gevent[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/nose2[${PYTHON_USEDEP}]
		dev-python/twisted[${PYTHON_USEDEP}]
		dev-python/tornado[${PYTHON_USEDEP}]
		net-misc/rabbitmq-server
	)
"

python_test() {
	nose2 -v || die "Tests failed with ${EPYTHON}"
}

src_test() {
	einfo "Starting rabbitmq"
	local -x RABBITMQ_LOG_BASE="${T}/rabbitmq/log"
	local -x RABBITMQ_MNESIA_BASE="${T}/rabbitmq/mnesia"
	local -x RABBITMQ_LOGS="${T}/rabbitmq.log"
	local -x RABBITMQ_PID_FILE="${T}/rabbitmq.pid"
	local -x RABBITMQ_ENABLED_PLUGINS_FILE="${T}/rabbitmq/enabled_plugins"
	/usr/libexec/rabbitmq/rabbitmq-server -p 5672:5672 &

	einfo "Waiting for rabbitmq to fully load"
	while ! { echo >/dev/tcp/localhost/5672 ; } &> /dev/null; do
		sleep 1
	done
	einfo "rabbitmq is ready"

	distutils-r1_src_test

	einfo "Stopping rabbitmq"
	kill "$(<"${RABBITMQ_PID_FILE}")" || die
}
