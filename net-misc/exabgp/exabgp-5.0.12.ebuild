# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{{11..15},{13..14}t} )
DISTUTILS_USE_PEP517=setuptools
inherit tmpfiles systemd distutils-r1

DESCRIPTION="The BGP swiss army knife of networking"
HOMEPAGE="https://github.com/Exa-Networks/exabgp"
SRC_URI="https://github.com/Exa-Networks/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	acct-group/exabgp
	acct-user/exabgp
"
BDEPEND="
	test? (
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/exabgp-5.0.8-paths.patch"
	"${FILESDIR}/exabgp-5.0.8-ip-path.patch"
	"${FILESDIR}/exabgp-5.0.8-healthcheck-allow-disable-metric.patch"
	"${FILESDIR}/exabgp-5.0.8-less-verbose-logging.patch"
)

EPYTEST_PLUGINS=(
	hypothesis
	pytest-asyncio
	pytest-timeout
)

distutils_enable_tests pytest

python_prepare_all() {
	# remove performance tests
	rm -rf tests/performance || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all

	newinitd "${FILESDIR}/${PN}.initd-r2" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}

	newtmpfiles "${FILESDIR}/exabgp.tmpfiles" ${PN}.conf
	systemd_dounit etc/systemd/*

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	keepdir /etc/exabgp

	doman doc/man/*.?
}

python_test() {
	local -a EPYTEST_DESELECT=(
		# tests that need network access
		tests/integration/test_connection_lifecycle.py::TestConnectionConcurrency::test_concurrent_read_write
		tests/integration/test_connection_lifecycle.py::TestConnectionStateManagement::test_connection_cleanup_on_close
		tests/integration/test_connection_lifecycle.py::TestConnectionStateManagement::test_multiple_close_calls
		tests/integration/test_connection_lifecycle.py::TestOutgoingConnectionLifecycle::test_outgoing_connection_establishment
		tests/integration/test_connection_lifecycle.py::TestOutgoingConnectionLifecycle::test_outgoing_full_message_exchange
		tests/integration/test_connection_lifecycle.py::TestOutgoingConnectionLifecycle::test_outgoing_receive_keepalive
		tests/integration/test_connection_lifecycle.py::TestOutgoingConnectionLifecycle::test_outgoing_send_keepalive
		tests/integration/test_connection_lifecycle.py::TestConnectionStateManagement::test_file_descriptor_tracking
		# unreliable test
		tests/fuzz/test_update_split.py::test_update_split_withdrawn_length_fuzzing
	)

	epytest
}

pkg_postinst() {
	tmpfiles_process ${PN}.conf
}
