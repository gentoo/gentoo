# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..11} )

CRATES="
	aho-corasick-0.7.19
	anyhow-1.0.71
	arc-swap-1.5.1
	autocfg-1.1.0
	bitflags-1.3.2
	blake2-0.10.6
	block-buffer-0.10.3
	cfg-if-1.0.0
	crypto-common-0.1.6
	digest-0.10.5
	generic-array-0.14.6
	hex-0.4.3
	indoc-1.0.7
	itoa-1.0.4
	lazy_static-1.4.0
	libc-0.2.135
	lock_api-0.4.9
	log-0.4.17
	memchr-2.5.0
	memoffset-0.6.5
	once_cell-1.15.0
	parking_lot-0.12.1
	parking_lot_core-0.9.3
	proc-macro2-1.0.52
	pyo3-0.17.3
	pyo3-build-config-0.17.3
	pyo3-ffi-0.17.3
	pyo3-log-0.8.1
	pyo3-macros-0.17.3
	pyo3-macros-backend-0.17.3
	pythonize-0.17.0
	quote-1.0.26
	redox_syscall-0.2.16
	regex-1.7.3
	regex-syntax-0.6.29
	ryu-1.0.11
	scopeguard-1.1.0
	serde-1.0.163
	serde_derive-1.0.163
	serde_json-1.0.96
	smallvec-1.10.0
	subtle-2.4.1
	syn-1.0.104
	syn-2.0.10
	target-lexicon-0.12.4
	typenum-1.15.0
	unicode-ident-1.0.5
	unindent-0.1.10
	version_check-0.9.4
	windows-sys-0.36.1
	windows_aarch64_msvc-0.36.1
	windows_i686_gnu-0.36.1
	windows_i686_msvc-0.36.1
	windows_x86_64_gnu-0.36.1
	windows_x86_64_msvc-0.36.1
"

inherit cargo distutils-r1 multiprocessing optfeature systemd

DESCRIPTION="Reference implementation of Matrix homeserver"
HOMEPAGE="
	https://matrix.org/
	https://github.com/matrix-org/synapse/
"
SRC_URI="
	https://github.com/matrix-org/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	$(cargo_crate_uris)
"

LICENSE="Apache-2.0"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD MIT Unicode-DFS-2016
"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE="postgres systemd test"
RESTRICT="!test? ( test )"

DEPEND="
	acct-user/synapse
	acct-group/synapse
"
RDEPEND="
	${DEPEND}
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/bcrypt[${PYTHON_USEDEP}]
	dev-python/bleach[${PYTHON_USEDEP}]
	>=dev-python/canonicaljson-2[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/ijson[${PYTHON_USEDEP}]
	dev-python/immutabledict[${PYTHON_USEDEP}]
	>=dev-python/jinja-3.0[${PYTHON_USEDEP}]
	dev-python/jsonschema[${PYTHON_USEDEP}]
	>=dev-python/matrix-common-1.3.0[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]
	dev-python/netaddr[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/phonenumbers[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP},webp]
	dev-python/prometheus-client[${PYTHON_USEDEP}]
	dev-python/pyasn1-modules[${PYTHON_USEDEP}]
	dev-python/pyasn1[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/pymacaroons[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/service_identity[${PYTHON_USEDEP}]
	dev-python/signedjson[${PYTHON_USEDEP}]
	dev-python/sortedcontainers[${PYTHON_USEDEP}]
	dev-python/treq[${PYTHON_USEDEP}]
	dev-python/twisted[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	dev-python/unpaddedbase64[${PYTHON_USEDEP}]
	postgres? ( dev-python/psycopg:2[${PYTHON_USEDEP}] )
	systemd? ( dev-python/python-systemd[${PYTHON_USEDEP}] )
"
BDEPEND="
	dev-python/setuptools-rust[${PYTHON_USEDEP}]
	test? (
		dev-python/idna[${PYTHON_USEDEP}]
		dev-python/parameterized[${PYTHON_USEDEP}]
		dev-python/pyicu[${PYTHON_USEDEP}]
		postgres? ( dev-db/postgresql[server] )
	)
"

# Rust extension
QA_FLAGS_IGNORED="usr/lib/python3.*/site-packages/synapse/synapse_rust.abi3.so"

src_test() {
	if use postgres; then
		einfo "Preparing postgres test instance"
		initdb --pgdata="${T}/pgsql" || die
		pg_ctl --wait --pgdata="${T}/pgsql" start \
			--options="-h '' -k '${T}'" || die
		createdb --host="${T}" synapse_test || die

		# See https://matrix-org.github.io/synapse/latest/development/contributing_guide.html#running-tests-under-postgresql
		local -x SYNAPSE_POSTGRES=1
		local -x SYNAPSE_POSTGRES_HOST="${T}"
	fi

	# This remove is necessary otherwise python is not able to locate
	# synapse_rust.abi3.so.
	rm -rf synapse || die

	nonfatal distutils-r1_src_test
	local ret=${?}

	if use postgres; then
		einfo "Stopping postgres test instance"
		pg_ctl --wait --pgdata="${T}/pgsql" stop || die
	fi

	[[ ${ret} -ne 0 ]] && die
}

python_test() {
	"${EPYTHON}" -m twisted.trial -j "$(makeopts_jobs)" tests
}

src_install() {
	distutils-r1_src_install
	keepdir /var/{lib,log}/synapse /etc/synapse
	fowners synapse:synapse /var/{lib,log}/synapse /etc/synapse
	fperms 0750 /var/{lib,log}/synapse /etc/synapse
	newinitd "${FILESDIR}/${PN}.initd-r1" "${PN}"
	systemd_dounit "${FILESDIR}/synapse.service"
}

pkg_postinst() {
	optfeature "Improve user search for international display names" dev-python/pyicu
	optfeature "Redis support" dev-python/txredisapi
	optfeature "VoIP relaying on your homeserver with turn" net-im/coturn

	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		einfo
		elog "In order to generate initial configuration run:"
		elog "sudo -u synapse synapse_homeserver \\"
		elog "    --server-name matrix.domain.tld \\"
		elog "    --config-path /etc/synapse/homeserver.yaml \\"
		elog "    --generate-config \\"
		elog "    --data-directory /var/lib/synapse \\"
		elog "    --report-stats=no"
		einfo
	else
		einfo
		elog "Please refer to upgrade notes if any special steps are required"
		elog "to upgrade from the version you currently have installed:"
		elog
		elog "  https://github.com/matrix-org/synapse/blob/develop/docs/upgrade.md"
		einfo
	fi
}
