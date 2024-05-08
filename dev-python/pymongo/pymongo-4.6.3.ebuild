# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit check-reqs distutils-r1

MY_P=mongo-python-driver-${PV}
DESCRIPTION="Python driver for MongoDB"
HOMEPAGE="
	https://github.com/mongodb/mongo-python-driver/
	https://pypi.org/project/pymongo/
"
SRC_URI="
	https://github.com/mongodb/mongo-python-driver/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="doc kerberos +native-extensions +test-full"

RDEPEND="
	<dev-python/dnspython-3.0.0[${PYTHON_USEDEP}]
	kerberos? ( dev-python/kerberos[${PYTHON_USEDEP}] )
"
BDEPEND="
	test? (
		test-full? (
			>=dev-db/mongodb-2.6.0
		)
	)
"

distutils_enable_sphinx doc
distutils_enable_tests pytest

reqcheck() {
	if use test && use test-full; then
		# During the tests, database size reaches 1.5G.
		local CHECKREQS_DISK_BUILD=1536M

		check-reqs_${1}
	fi
}

pkg_pretend() {
	reqcheck pkg_pretend
}

pkg_setup() {
	reqcheck pkg_setup
}

python_compile() {
	# causes build errors to be fatal
	local -x TOX_ENV_NAME=whatever
	local DISTUTILS_ARGS=()
	# unconditionally implicitly disabled on pypy3
	if ! use native-extensions; then
		DISTUTILS_ARGS+=( --no_ext )
	else
		export PYMONGO_C_EXT_MUST_BUILD=1
	fi

	distutils-r1_python_compile
}

python_test() {
	rm -rf bson pymongo || die

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local EPYTEST_DESELECT=(
		# network-sandbox
		test/test_client.py::ClientUnitTest::test_connection_timeout_ms_propagates_to_DNS_resolver
		test/test_client.py::TestClient::test_service_name_from_kwargs
		test/test_client.py::TestClient::test_srv_max_hosts_kwarg
		test/test_dns.py::TestCaseInsensitive::test_connect_case_insensitive
		test/test_srv_polling.py
		test/test_uri_spec.py::TestAllScenarios::test_test_uri_options_srv-options_SRV_URI_with_custom_srvServiceName
		test/test_uri_spec.py::TestAllScenarios::test_test_uri_options_srv-options_SRV_URI_with_invalid_type_for_srvMaxHosts
		test/test_uri_spec.py::TestAllScenarios::test_test_uri_options_srv-options_SRV_URI_with_negative_integer_for_srvMaxHosts
		test/test_uri_spec.py::TestAllScenarios::test_test_uri_options_srv-options_SRV_URI_with_positive_srvMaxHosts_and_loadBalanced=fa
		test/test_uri_spec.py::TestAllScenarios::test_test_uri_options_srv-options_SRV_URI_with_srvMaxHosts
		test/test_uri_spec.py::TestAllScenarios::test_test_uri_options_srv-options_SRV_URI_with_srvMaxHosts=0_and_loadBalanced=true
		test/test_uri_spec.py::TestAllScenarios::test_test_uri_options_srv-options_SRV_URI_with_srvMaxHosts=0_and_replicaSet

		# broken regularly by changes in mypy
		test/test_typing.py::TestMypyFails::test_mypy_failures
	)

	if ! use test-full; then
		# .invalid is guaranteed to return NXDOMAIN per RFC 6761
		local -x DB_IP=mongodb.invalid
		epytest
		return
	fi

	# Yes, we need TCP/IP for that...
	local -x DB_IP=127.0.0.1
	local -x DB_PORT=27000

	local dbpath=${TMPDIR}/mongo.db
	local logpath=${TMPDIR}/mongod.log

	# Now, the hard part: we need to find a free port for mongod.
	# We're just trying to run it random port numbers and check the log
	# for bind errors. It shall be noted that 'mongod --fork' does not
	# return failure when it fails to bind.

	mkdir -p "${dbpath}" || die
	while true; do
		ebegin "Trying to start mongod on port ${DB_PORT}"

		LC_ALL=C \
		mongod --dbpath "${dbpath}" --nojournal \
			--bind_ip ${DB_IP} --port ${DB_PORT} \
			--unixSocketPrefix "${TMPDIR}" \
			--logpath "${logpath}" --fork \
		&& sleep 2

		# Now we need to check if the server actually started...
		if [[ ${?} -eq 0 && -S "${TMPDIR}"/mongodb-${DB_PORT}.sock ]]; then
			# yay!
			eend 0
			break
		elif grep -q 'Address already in use' "${logpath}"; then
			# ay, someone took our port!
			eend 1
			: $(( DB_PORT += 1 ))
			continue
		else
			eend 1
			eerror "Unable to start mongod for tests. See the server log:"
			eerror "	${logpath}"
			die "Unable to start mongod for tests."
		fi
	done

	local failed
	nonfatal epytest || failed=1

	mongod --dbpath "${dbpath}" --shutdown || die

	[[ ${failed} ]] && die "Tests fail with ${EPYTHON}"

	rm -rf "${dbpath}" || die
}
