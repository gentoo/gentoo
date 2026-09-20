# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Low-level AMQP client for Python (fork of amqplib)"
HOMEPAGE="
	https://github.com/celery/py-amqp/
	https://pypi.org/project/amqp/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="extras"

RDEPEND="
	>=dev-python/vine-5.0.0[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs \
	'>=dev-python/sphinx-celery-2.1.3'
EPYTEST_PLUGINS=( pytest-rerunfailures )
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# fails when gssapi is installed (how does that test make sense?!)
	t/unit/test_sasl.py::test_SASL::test_gssapi_missing
)

src_test() {
	einfo "Starting rabbitmq"
	# TODO: enable TLS?
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

python_test() {
	epytest -k "not tls"
}

python_install_all() {
	if use extras; then
		insinto /usr/share/${PF}/extras
		doins -r extra
	fi
	distutils-r1_python_install_all
}
