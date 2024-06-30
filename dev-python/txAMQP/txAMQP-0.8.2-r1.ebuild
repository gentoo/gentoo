# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1

MY_P="${PN,,}-${PV}"

DESCRIPTION="Python library for communicating with AMQP peers using Twisted"
HOMEPAGE="https://github.com/txamqp/txamqp"
# pypi tarball misses doc files
# https://github.com/txamqp/txamqp/pull/10
SRC_URI="
	https://github.com/txamqp/txamqp/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/twisted[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
		net-misc/rabbitmq-server
	)
"

python_test() {
	cd src || die
	# tests look for those files relatively to modules
	cp -r specs "${BUILD_DIR}"/lib || die

	TXAMQP_BROKER=RABBITMQ "${EPYTHON}" -m twisted.trial txamqp
	local ret=${?}

	[[ ${ret} == 0 ]] || die "Tests failed with ${EPYTHON}"
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

python_install_all() {
	local DOCS=( doc/* )

	distutils-r1_python_install_all
}
