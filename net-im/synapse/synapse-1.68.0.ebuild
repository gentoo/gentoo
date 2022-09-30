# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=poetry

CRATES="
	autocfg-1.1.0
	bitflags-1.3.2
	blake2-0.10.4
	block-buffer-0.10.3
	cfg-if-1.0.0
	crypto-common-0.1.6
	digest-0.10.5
	generic-array-0.14.6
	hex-0.4.3
	indoc-1.0.7
	libc-0.2.132
	lock_api-0.4.7
	once_cell-1.13.1
	parking_lot-0.12.1
	parking_lot_core-0.9.3
	proc-macro2-1.0.43
	pyo3-0.16.6
	pyo3-build-config-0.16.6
	pyo3-ffi-0.16.6
	pyo3-macros-0.16.6
	pyo3-macros-backend-0.16.6
	quote-1.0.21
	redox_syscall-0.2.16
	scopeguard-1.1.0
	smallvec-1.9.0
	subtle-2.4.1
	syn-1.0.99
	target-lexicon-0.12.4
	typenum-1.15.0
	unicode-ident-1.0.3
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

MY_PV="${PV/_rc/rc}"

DESCRIPTION="Reference implementation of Matrix homeserver"
HOMEPAGE="
	https://matrix.org/
	https://github.com/matrix-org/synapse/
"
SRC_URI="
	https://github.com/matrix-org/${PN}/archive/v${MY_PV}.tar.gz
		-> ${P}.gh.tar.gz
	$(cargo_crate_uris)
"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="Apache-2.0"
# Additional licenses needed for Rust crates
LICENSE+=" Apache-2.0-with-LLVM-exceptions BSD MIT Unicode-DFS-2016"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE="postgres systemd test"
RESTRICT="!test? ( test )"

DEPEND="
	acct-user/synapse
	acct-group/synapse
"
RDEPEND="${DEPEND}
	$(python_gen_cond_dep '
		dev-python/attrs[${PYTHON_USEDEP}]
		dev-python/bcrypt[${PYTHON_USEDEP}]
		dev-python/bleach[${PYTHON_USEDEP}]
		dev-python/canonicaljson[${PYTHON_USEDEP}]
		dev-python/cryptography[${PYTHON_USEDEP}]
		dev-python/frozendict[${PYTHON_USEDEP}]
		dev-python/ijson[${PYTHON_USEDEP}]
		>=dev-python/jinja-3.0[${PYTHON_USEDEP}]
		dev-python/jsonschema[${PYTHON_USEDEP}]
		>=dev-python/matrix-common-1.3.0[${PYTHON_USEDEP}]
		dev-python/msgpack[${PYTHON_USEDEP}]
		dev-python/netaddr[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/phonenumbers[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP},webp]
		dev-python/prometheus_client[${PYTHON_USEDEP}]
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
	')
"
BDEPEND="
	$(python_gen_cond_dep 'dev-python/setuptools-rust[${PYTHON_USEDEP}]')
	test? (
		$(python_gen_cond_dep '
			dev-python/idna[${PYTHON_USEDEP}]
			dev-python/parameterized[${PYTHON_USEDEP}]
		')
		postgres? ( dev-db/postgresql[server] )
	)
"

# Rust extension
QA_FLAGS_IGNORED="usr/lib/python3.*/site-packages/synapse/synapse_rust.abi3.so"

src_test() {
	if use postgres; then
		initdb --pgdata="${T}/pgsql" || die
		pg_ctl --wait --pgdata="${T}/pgsql" start \
			--options="-h '' -k '${T}'" || die
		createdb --host="${T}" synapse_test || die

		# See https://matrix-org.github.io/synapse/latest/development/contributing_guide.html#running-tests-under-postgresql
		local -x SYNAPSE_POSTGRES=1
		local -x SYNAPSE_POSTGRES_HOST="${T}"
	fi

	# This move is necessary otherwise python is not able to locate
	# synapse_rust.abi3.so.
	mv synapse{,.hidden} || die

	distutils-r1_src_test

	if use postgres; then
		pg_ctl --wait --pgdata="${T}/pgsql" stop || die
	fi
}

python_test() {
	"${EPYTHON}" -m twisted.trial -j "$(makeopts_jobs)" tests || die "Tests failed with ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install
	keepdir /var/{lib,log}/synapse /etc/synapse
	fowners synapse:synapse /var/{lib,log}/synapse /etc/synapse
	fperms 0750 /var/{lib,log}/synapse /etc/synapse
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	systemd_dounit "${FILESDIR}/synapse.service"
}

pkg_postinst() {
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
		einfo "Please refer to upgrade notes if any special steps are required"
		einfo "to upgrade from the version you currently have installed:"
		einfo
		einfo "  https://github.com/matrix-org/synapse/blob/develop/docs/upgrade.md"
		einfo
	fi
}
