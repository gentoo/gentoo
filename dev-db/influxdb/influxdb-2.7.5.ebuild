# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler32@1.2.0
	ahash@0.7.6
	aho-corasick@0.7.20
	android_system_properties@0.1.5
	ansi_term@0.12.1
	anyhow@1.0.70
	arrayvec@0.5.2
	atty@0.2.14
	autocfg@1.1.0
	bitflags@1.3.2
	bitflags@2.0.2
	bumpalo@3.12.0
	cast@0.3.0
	cc@1.0.79
	cfg-if@1.0.0
	chrono@0.4.24
	clap@2.34.0
	codespan-reporting@0.11.1
	colored@2.0.0
	core-foundation-sys@0.8.4
	crc32fast@1.3.2
	criterion-plot@0.4.5
	criterion@0.3.6
	crossbeam-channel@0.5.7
	crossbeam-deque@0.8.3
	crossbeam-epoch@0.9.14
	crossbeam-utils@0.8.15
	csv-core@0.1.10
	csv@1.2.1
	ctor@0.1.26
	cxx-build@1.0.94
	cxx@1.0.94
	cxxbridge-flags@1.0.94
	cxxbridge-macro@1.0.94
	derivative@2.2.0
	derive_more@0.99.17
	diff@0.1.13
	dissimilar@1.0.6
	either@1.8.1
	ena@0.14.2
	env_logger@0.9.3
	errno-dragonfly@0.1.2
	errno@0.3.0
	expect-test@1.4.1
	fallible-iterator@0.2.0
	fallible-streaming-iterator@0.1.9
	fastrand@1.9.0
	flatbuffers@22.12.6
	fnv@1.0.7
	form_urlencoded@1.1.0
	getrandom@0.2.8
	half@1.8.2
	hashbrown@0.12.3
	hashlink@0.8.1
	heck@0.3.3
	hermit-abi@0.1.19
	hermit-abi@0.2.6
	hermit-abi@0.3.1
	humantime@2.1.0
	iana-time-zone-haiku@0.1.1
	iana-time-zone@0.1.56
	idna@0.3.0
	indexmap@1.9.3
	instant@0.1.12
	io-lifetimes@1.0.10
	itertools@0.10.5
	itoa@1.0.6
	js-sys@0.3.61
	lazy_static@1.4.0
	libc@0.2.141
	libflate@1.3.0
	libflate_lz77@1.2.0
	libsqlite3-sys@0.26.0
	link-cplusplus@1.0.8
	linux-raw-sys@0.3.1
	lock_api@0.4.9
	log@0.4.17
	lsp-types@0.91.1
	maplit@1.0.2
	memchr@2.5.0
	memoffset@0.8.0
	num-integer@0.1.45
	num-traits@0.2.15
	num_cpus@1.15.0
	once_cell@1.17.1
	oorandom@11.1.3
	ordered-float@3.6.0
	output_vt100@0.1.3
	pad@0.1.6
	parking_lot@0.11.2
	parking_lot_core@0.8.6
	percent-encoding@2.2.0
	pkg-config@0.3.26
	plotters-backend@0.3.4
	plotters-svg@0.3.3
	plotters@0.3.4
	pretty@0.11.3
	pretty_assertions@1.3.0
	proc-macro-error-attr@1.0.4
	proc-macro-error@1.0.4
	proc-macro2@1.0.56
	pulldown-cmark@0.9.2
	quote@1.0.26
	rayon-core@1.11.0
	rayon@1.7.0
	redox_syscall@0.2.16
	redox_syscall@0.3.5
	regex-syntax@0.6.29
	regex@1.7.3
	rle-decode-fast@1.0.3
	rusqlite@0.29.0
	rustc-hash@1.1.0
	rustc_version@0.4.0
	rustix@0.37.7
	ryu@1.0.13
	salsa-macros@0.17.0-pre.2
	salsa@0.17.0-pre.2
	same-file@1.0.6
	scopeguard@1.1.0
	scratch@1.0.5
	semver@1.0.17
	serde@1.0.159
	serde_cbor@0.11.2
	serde_derive@1.0.159
	serde_json@1.0.95
	serde_repr@0.1.12
	smallvec@1.10.0
	strsim@0.8.0
	structopt-derive@0.4.18
	structopt@0.3.26
	syn@1.0.109
	syn@2.0.13
	tempfile@3.5.0
	termcolor@1.2.0
	textwrap@0.11.0
	thiserror-impl@1.0.40
	thiserror@1.0.40
	tinytemplate@1.2.1
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	typed-arena@2.0.2
	unicase@2.6.0
	unicode-bidi@0.3.13
	unicode-ident@1.0.8
	unicode-normalization@0.1.22
	unicode-segmentation@1.10.1
	unicode-width@0.1.10
	url@2.3.1
	vcpkg@0.2.15
	vec_map@0.8.2
	version_check@0.9.4
	walkdir@2.3.3
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.84
	wasm-bindgen-macro-support@0.2.84
	wasm-bindgen-macro@0.2.84
	wasm-bindgen-shared@0.2.84
	wasm-bindgen@0.2.84
	web-sys@0.3.61
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.5
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.45.0
	windows-sys@0.48.0
	windows-targets@0.42.2
	windows-targets@0.48.0
	windows@0.48.0
	windows_aarch64_gnullvm@0.42.2
	windows_aarch64_gnullvm@0.48.0
	windows_aarch64_msvc@0.42.2
	windows_aarch64_msvc@0.48.0
	windows_i686_gnu@0.42.2
	windows_i686_gnu@0.48.0
	windows_i686_msvc@0.42.2
	windows_i686_msvc@0.48.0
	windows_x86_64_gnu@0.42.2
	windows_x86_64_gnu@0.48.0
	windows_x86_64_gnullvm@0.42.2
	windows_x86_64_gnullvm@0.48.0
	windows_x86_64_msvc@0.42.2
	windows_x86_64_msvc@0.48.0
	yansi@0.5.1
"

inherit cargo go-module systemd

DESCRIPTION="Scalable datastore for metrics, events, and real-time analytics"
HOMEPAGE="https://www.influxdata.com"

FLUX_PV="0.194.5"

SRC_URI="https://github.com/influxdata/influxdb/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/influxdata/ui/releases/download/OSS-v2.7.1/build.tar.gz -> ${P}-assets.tar.gz"
SRC_URI+=" https://gentoo.kropotkin.rocks/go-pkgs/${P}-deps.tar.xz"
SRC_URI+=" ${CARGO_CRATE_URIS}"

LICENSE="Apache-2.0 BSD BSD-2 EPL-2.0 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig
	<virtual/rust-1.78.0
"

DEPEND="
	acct-group/influxdb
	acct-user/influxdb
"
RDEPEND="${DEPEND}"

src_unpack() {
	cargo_src_unpack
}

src_prepare() {
	default

	local data_dir
	data_dir="${S}/static/data"
	mkdir "${data_dir}" || die
	mv "${WORKDIR}/build" "${data_dir}" || die
}

src_compile() {
	mv "${WORKDIR}/go-mod" "${WORKDIR}/go-mod-tmp" || die
	mv "${WORKDIR}/go-mod-tmp/github.com/influxdata/pkg-config@v0.2.11/go-mod" "${WORKDIR}/go-mod" || die
	cd "${WORKDIR}"/go-mod-tmp/github.com/influxdata/pkg-config* || die
	ego build .
	mv "${WORKDIR}/go-mod" "${WORKDIR}/go-mod-tmp/github.com/influxdata/pkg-config@v0.2.11" || die
	mv "${WORKDIR}/go-mod-tmp" "${WORKDIR}/go-mod" || die

	cd "${WORKDIR}/go-mod/github.com/influxdata/flux@v${FLUX_PV}/libflux" || die
	cargo_src_compile

	cd "${S}" || die

	export PKG_CONFIG="${WORKDIR}/go-mod/github.com/influxdata/pkg-config@v0.2.11/pkg-config"
	ego generate ./static
	GOBIN="${S}/bin" \
		ego install \
			-tags 'assets,noasm,sqlite_json,sqlite_foreign_keys' \
			-ldflags="-X main.version=${PV}" \
		./...
}

src_test() {
	ego test ./tests
}

src_install() {
	dobin bin/influx*
	dodoc *.md
	cd .circleci/scripts/package/influxdb2/fs || die
	systemd_dounit usr/lib/influxdb/scripts/influxdb.service
	exeinto /usr/lib/influxdb/scripts
	doexe usr/lib/influxdb/scripts/influxd-systemd-start.sh
	exeinto /usr/share/influxdb
	doexe usr/share/influxdb/influxdb2-upgrade.sh
	newconfd "${FILESDIR}"/influxdb.confd-r1 influxdb
	newinitd "${FILESDIR}"/influxdb.initd-r1 influxdb
	keepdir /var/log/influxdb
	fowners influxdb:influxdb /var/log/influxdb

	newenvd - "99${PN}" <<-_EOF_
		INFLUXD_CONFIG_PATH="/etc/influxdb"
	_EOF_
}

pkg_postinst() {
	elog "Upgrading from InfluxDB1.x requires migration of time series data."
	elog "See https://docs.influxdata.com/influxdb/v2.7/upgrade/v1-to-v2/"
	elog "Keep in mind that some applications not compatible with InfluxDB 2.x"
	elog "may stop working."

	ewarn "The InfluxDB command line client has been moved to dev-db/influx-cli"
	ewarn "You will need to install it separately"
}
