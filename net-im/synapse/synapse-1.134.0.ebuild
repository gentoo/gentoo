# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{11..13} )

CRATES="
	addr2line@0.24.2
	adler2@2.0.0
	aho-corasick@1.1.3
	anyhow@1.0.98
	arc-swap@1.7.1
	atomic-waker@1.1.2
	autocfg@1.3.0
	backtrace@0.3.74
	base64@0.21.7
	base64@0.22.1
	bitflags@2.8.0
	blake2@0.10.6
	block-buffer@0.10.4
	bumpalo@3.16.0
	bytes@1.10.1
	cc@1.2.19
	cfg-if@1.0.0
	cfg_aliases@0.2.1
	core-foundation-sys@0.8.7
	core-foundation@0.10.0
	core_maths@0.1.1
	cpufeatures@0.2.12
	crypto-common@0.1.6
	digest@0.10.7
	displaydoc@0.2.5
	equivalent@1.0.2
	fnv@1.0.7
	form_urlencoded@1.2.1
	futures-channel@0.3.31
	futures-core@0.3.31
	futures-executor@0.3.31
	futures-io@0.3.31
	futures-macro@0.3.31
	futures-sink@0.3.31
	futures-task@0.3.31
	futures-util@0.3.31
	futures@0.3.31
	generic-array@0.14.7
	getrandom@0.2.15
	getrandom@0.3.1
	gimli@0.31.1
	h2@0.4.9
	hashbrown@0.15.2
	headers-core@0.3.0
	headers@0.4.1
	heck@0.5.0
	hex@0.4.3
	http-body-util@0.1.3
	http-body@1.0.1
	http@1.3.1
	httparse@1.10.1
	httpdate@1.0.3
	hyper-rustls@0.27.5
	hyper-util@0.1.14
	hyper@1.6.0
	icu_collections@1.5.0
	icu_collections@2.0.0
	icu_locale@2.0.0
	icu_locale_core@2.0.0
	icu_locale_data@2.0.0
	icu_locid@1.5.0
	icu_locid_transform@1.5.0
	icu_locid_transform_data@1.5.1
	icu_normalizer@1.5.0
	icu_normalizer_data@1.5.1
	icu_properties@1.5.1
	icu_properties_data@1.5.1
	icu_provider@1.5.0
	icu_provider@2.0.0
	icu_provider_macros@1.5.0
	icu_segmenter@2.0.0
	icu_segmenter_data@2.0.0
	idna@1.0.3
	idna_adapter@1.2.0
	indexmap@2.9.0
	indoc@2.0.5
	io-uring@0.7.8
	ipnet@2.11.0
	iri-string@0.7.8
	itoa@1.0.11
	js-sys@0.3.77
	lazy_static@1.5.0
	libc@0.2.172
	libm@0.2.15
	litemap@0.7.5
	litemap@0.8.0
	log@0.4.27
	memchr@2.7.2
	memoffset@0.9.1
	mime@0.3.17
	miniz_oxide@0.8.8
	mio@1.0.3
	object@0.36.7
	once_cell@1.19.0
	openssl-probe@0.1.6
	percent-encoding@2.3.1
	pin-project-lite@0.2.16
	pin-utils@0.1.0
	portable-atomic@1.6.0
	potential_utf@0.1.2
	ppv-lite86@0.2.17
	proc-macro2@1.0.89
	pyo3-build-config@0.25.1
	pyo3-ffi@0.25.1
	pyo3-log@0.12.4
	pyo3-macros-backend@0.25.1
	pyo3-macros@0.25.1
	pyo3@0.25.1
	pythonize@0.25.0
	quinn-proto@0.11.8
	quinn-udp@0.5.11
	quinn@0.11.5
	quote@1.0.36
	rand@0.8.5
	rand@0.9.0
	rand_chacha@0.3.1
	rand_chacha@0.9.0
	rand_core@0.6.4
	rand_core@0.9.0
	regex-automata@0.4.8
	regex-syntax@0.8.5
	regex@1.11.1
	reqwest@0.12.22
	ring@0.17.14
	rustc-demangle@0.1.24
	rustc-hash@2.1.1
	rustls-native-certs@0.8.1
	rustls-pki-types@1.11.0
	rustls-webpki@0.103.1
	rustls@0.23.26
	rustversion@1.0.20
	ryu@1.0.18
	schannel@0.1.27
	security-framework-sys@2.14.0
	security-framework@3.2.0
	serde@1.0.219
	serde_derive@1.0.219
	serde_json@1.0.140
	serde_urlencoded@0.7.1
	sha1@0.10.6
	sha2@0.10.9
	shlex@1.3.0
	slab@0.4.9
	smallvec@1.15.0
	socket2@0.5.9
	stable_deref_trait@1.2.0
	subtle@2.5.0
	syn@2.0.85
	sync_wrapper@1.0.2
	synstructure@0.13.2
	target-lexicon@0.13.2
	thiserror-impl@1.0.65
	thiserror@1.0.65
	tinystr@0.7.6
	tinystr@0.8.1
	tinyvec@1.9.0
	tinyvec_macros@0.1.1
	tokio-rustls@0.26.2
	tokio-util@0.7.15
	tokio@1.46.1
	tower-http@0.6.6
	tower-layer@0.3.3
	tower-service@0.3.3
	tower@0.5.2
	tracing-core@0.1.34
	tracing@0.1.41
	try-lock@0.2.5
	typenum@1.17.0
	ulid@1.2.1
	unicode-ident@1.0.12
	unindent@0.2.3
	untrusted@0.9.0
	url@2.5.4
	utf16_iter@1.0.5
	utf8_iter@1.0.4
	version_check@0.9.4
	want@0.3.1
	wasi@0.11.0+wasi-snapshot-preview1
	wasi@0.13.3+wasi-0.2.2
	wasm-bindgen-backend@0.2.100
	wasm-bindgen-futures@0.4.50
	wasm-bindgen-macro-support@0.2.100
	wasm-bindgen-macro@0.2.100
	wasm-bindgen-shared@0.2.100
	wasm-bindgen@0.2.100
	wasm-streams@0.4.2
	web-sys@0.3.77
	web-time@1.1.0
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
	wit-bindgen-rt@0.33.0
	write16@1.0.0
	writeable@0.5.5
	writeable@0.6.1
	yoke-derive@0.7.5
	yoke-derive@0.8.0
	yoke@0.7.5
	yoke@0.8.0
	zerocopy-derive@0.8.17
	zerocopy@0.8.17
	zerofrom-derive@0.1.6
	zerofrom@0.1.6
	zeroize@1.8.1
	zerotrie@0.2.2
	zerovec-derive@0.10.3
	zerovec-derive@0.11.1
	zerovec@0.10.4
	zerovec@0.11.2
"

inherit cargo distutils-r1 multiprocessing optfeature systemd

DESCRIPTION="Reference implementation of Matrix homeserver"
HOMEPAGE="
	https://matrix.org/
	https://github.com/element-hq/synapse
"
SRC_URI="
	https://github.com/element-hq/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="AGPL-3+"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD ISC MIT Unicode-3.0
	Unicode-DFS-2016
"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"
IUSE="postgres selinux systemd test"
RESTRICT="!test? ( test )"

RDEPEND="
	acct-user/synapse
	acct-group/synapse
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/bcrypt[${PYTHON_USEDEP}]
	dev-python/bleach[${PYTHON_USEDEP}]
	>=dev-python/canonicaljson-2[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/ijson[${PYTHON_USEDEP}]
	dev-python/immutabledict[${PYTHON_USEDEP}]
	>=dev-python/jinja2-3.0[${PYTHON_USEDEP}]
	dev-python/jsonschema[${PYTHON_USEDEP}]
	>=dev-python/matrix-common-1.3.0[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]
	dev-python/netaddr[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/phonenumbers[${PYTHON_USEDEP}]
	>=dev-python/pillow-10.0.1[${PYTHON_USEDEP},webp]
	dev-python/prometheus-client[${PYTHON_USEDEP}]
	dev-python/pyasn1-modules[${PYTHON_USEDEP}]
	dev-python/pyasn1[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/pymacaroons[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	>=dev-python/python-multipart-0.0.12-r100[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/service-identity[${PYTHON_USEDEP}]
	dev-python/signedjson[${PYTHON_USEDEP}]
	dev-python/sortedcontainers[${PYTHON_USEDEP}]
	dev-python/treq[${PYTHON_USEDEP}]
	dev-python/twisted[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	dev-python/unpaddedbase64[${PYTHON_USEDEP}]
	postgres? ( dev-python/psycopg:2[${PYTHON_USEDEP}] )
	selinux? ( sec-policy/selinux-matrixd )
	systemd? ( dev-python/python-systemd[${PYTHON_USEDEP}] )
"
BDEPEND="
	acct-user/synapse
	acct-group/synapse
	dev-python/setuptools-rust[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/hiredis[${PYTHON_USEDEP}]
		dev-python/idna[${PYTHON_USEDEP}]
		dev-python/parameterized[${PYTHON_USEDEP}]
		dev-python/txredisapi[${PYTHON_USEDEP}]
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
		elog "  https://github.com/element-hq/synapse/blob/develop/docs/upgrade.md"
		einfo
	fi
}
