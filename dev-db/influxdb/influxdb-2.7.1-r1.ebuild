# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler32-1.2.0
	ahash-0.7.6
	aho-corasick-0.7.18
	ansi_term-0.11.0
	ansi_term-0.12.1
	anyhow-1.0.56
	arrayvec-0.5.2
	atty-0.2.14
	autocfg-1.0.1
	bitflags-1.3.2
	bstr-0.2.17
	bumpalo-3.12.0
	cast-0.2.7
	cfg-if-1.0.0
	chrono-0.4.19
	clap-2.33.3
	codespan-reporting-0.11.1
	colored-2.0.0
	crc32fast-1.2.1
	criterion-0.3.5
	criterion-plot-0.4.4
	crossbeam-channel-0.5.1
	crossbeam-deque-0.8.1
	crossbeam-epoch-0.9.5
	crossbeam-utils-0.8.8
	csv-1.1.6
	csv-core-0.1.10
	ctor-0.1.21
	derivative-2.2.0
	derive_more-0.99.17
	diff-0.1.12
	dissimilar-1.0.3
	either-1.6.1
	ena-0.14.0
	env_logger-0.9.0
	expect-test-1.2.2
	fallible-iterator-0.2.0
	fallible-streaming-iterator-0.1.9
	fastrand-1.7.0
	flatbuffers-22.9.29
	fnv-1.0.7
	form_urlencoded-1.0.1
	getrandom-0.2.6
	half-1.8.2
	hashbrown-0.11.2
	hashlink-0.7.0
	heck-0.3.3
	hermit-abi-0.1.19
	humantime-2.1.0
	idna-0.2.3
	indexmap-1.8.1
	instant-0.1.12
	itertools-0.10.1
	itoa-0.4.8
	itoa-1.0.1
	js-sys-0.3.55
	lazy_static-1.4.0
	libc-0.2.121
	libflate-1.2.0
	libflate_lz77-1.1.0
	libsqlite3-sys-0.23.2
	lock_api-0.4.6
	log-0.4.16
	lsp-types-0.91.1
	maplit-1.0.2
	matches-0.1.9
	memchr-2.4.1
	memoffset-0.6.4
	num-integer-0.1.44
	num-traits-0.2.14
	num_cpus-1.13.0
	once_cell-1.10.0
	oorandom-11.1.3
	ordered-float-3.2.0
	output_vt100-0.1.2
	pad-0.1.6
	parking_lot-0.11.2
	parking_lot_core-0.8.5
	percent-encoding-2.1.0
	pkg-config-0.3.25
	plotters-0.3.1
	plotters-backend-0.3.2
	plotters-svg-0.3.1
	pretty-0.11.2
	pretty_assertions-1.2.1
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.32
	pulldown-cmark-0.9.1
	quote-1.0.10
	rayon-1.5.2
	rayon-core-1.9.2
	redox_syscall-0.2.10
	regex-1.5.5
	regex-automata-0.1.10
	regex-syntax-0.6.25
	remove_dir_all-0.5.3
	rle-decode-fast-1.0.1
	rusqlite-0.26.3
	rustc-hash-1.1.0
	rustc_version-0.4.0
	ryu-1.0.5
	salsa-0.17.0-pre.2
	salsa-macros-0.17.0-pre.2
	same-file-1.0.6
	scopeguard-1.1.0
	semver-1.0.4
	serde-1.0.136
	serde_cbor-0.11.2
	serde_derive-1.0.136
	serde_json-1.0.79
	serde_repr-0.1.7
	smallvec-1.7.0
	strsim-0.8.0
	structopt-0.3.26
	structopt-derive-0.4.18
	syn-1.0.81
	tempfile-3.3.0
	termcolor-1.1.2
	textwrap-0.11.0
	thiserror-1.0.30
	thiserror-impl-1.0.30
	time-0.1.43
	tinytemplate-1.2.1
	tinyvec-1.5.1
	tinyvec_macros-0.1.0
	typed-arena-2.0.1
	unicase-2.6.0
	unicode-bidi-0.3.7
	unicode-normalization-0.1.19
	unicode-segmentation-1.8.0
	unicode-width-0.1.9
	unicode-xid-0.2.2
	url-2.2.2
	vcpkg-0.2.15
	vec_map-0.8.2
	version_check-0.9.3
	walkdir-2.3.2
	wasi-0.10.2+wasi-snapshot-preview1
	wasm-bindgen-0.2.78
	wasm-bindgen-backend-0.2.78
	wasm-bindgen-macro-0.2.78
	wasm-bindgen-macro-support-0.2.78
	wasm-bindgen-shared-0.2.78
	web-sys-0.3.55
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo go-module systemd

DESCRIPTION="Scalable datastore for metrics, events, and real-time analytics"
HOMEPAGE="https://www.influxdata.com"

SRC_URI="https://github.com/influxdata/influxdb/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/influxdata/ui/releases/download/OSS-v${PV}/build.tar.gz -> ${P}-assets.tar.gz"
SRC_URI+=" https://gentoo.kropotkin.rocks/go-pkgs/${P}-deps.tar.xz"
SRC_URI+=" $(cargo_crate_uris)"

LICENSE="Apache-2.0 BSD BSD-2 EPL-2.0 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="virtual/pkgconfig"

COMMON_DEPEND="
	acct-group/influxdb
	acct-user/influxdb
"

DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

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

	cd "${WORKDIR}/go-mod/github.com/influxdata/flux@v0.193.0/libflux" || die
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
	cd .circleci/package/fs
	systemd_dounit usr/lib/influxdb/scripts/influxdb.service
	dodir /usr/lib/influxdb/scripts
	exeinto /usr/lib/influxdb/scripts
	doexe usr/lib/influxdb/scripts/influxd-systemd-start.sh
	dodir /usr/share/influxdb
	exeinto /usr/share/influxdb
	doexe usr/share/influxdb/influxdb2-upgrade.sh
	newconfd "${FILESDIR}"/influxdb.confd influxdb
	newinitd "${FILESDIR}"/influxdb.initd influxdb
	keepdir /var/log/influxdb
	fowners influxdb:influxdb /var/log/influxdb
}

pkg_postinst() {
	elog "Upgrading from InfluxDB1.x requires migration of time series data."
	elog "See https://docs.influxdata.com/influxdb/v2.7/upgrade/v1-to-v2/"
	elog "Keep in mind that some applications not compatible with InfluxDB 2.x"
	elog "may stop working."

	ewarn "The InfluxDB command line client has been moved to dev-db/influx-cli"
	ewarn "You will need to install it separately"
}
