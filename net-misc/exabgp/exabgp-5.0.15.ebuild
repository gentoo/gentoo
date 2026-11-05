# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{{12..15},{13..14}t} )
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

	# remove tests that need internet access
	rm -f tests/unit/test_flow_needs_a_match.py || die

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
		tests/unit/test_gates_are_wired.py::TestEveryTestDirectoryIsActuallyRun::test_the_walk_found_the_directories
		tests/unit/test_gates_are_wired.py::TestEveryTestDirectoryIsActuallyRun::test_the_ones_that_were_unwired_are_among_them
		tests/unit/test_network_tcp.py::TestSocketCreation::test_a_refused_setsockopt_is_reported_as_itself
		tests/unit/test_network_tcp.py::TestSocketCreation::test_a_real_interface_is_bound_with_a_nul_terminated_name
		tests/unit/test_validate_survives_a_route_with_no_nlri.py::test_a_route_which_reads_back_no_nlri_is_reported_not_raised
		tests/unit/test_validate_survives_a_route_with_no_nlri.py::test_a_flow_route_with_a_match_still_validates
		# unreliable test
		tests/fuzz/test_update_split.py::test_update_split_withdrawn_length_fuzzing
	)

	epytest
}

pkg_postinst() {
	tmpfiles_process ${PN}.conf
}
