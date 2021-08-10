# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

[[ ${PV} == *_pre???????? ]] && \
	COMMIT="7f1b6d4e9e4b6a3216a78c23df745bcf8fc84021"

CRATES="
	ansi_term-0.11.0
	approx-0.3.2
	arc-swap-0.4.4
	async-trait-0.1.24
	atty-0.2.14
	autocfg-1.0.0
	bitflags-1.2.1
	bytes-0.5.4
	c2-chacha-0.2.3
	cc-1.0.50
	cfg-if-0.1.10
	claim-0.4.0
	clap-2.33.0
	core-foundation-0.6.4
	core-foundation-sys-0.6.2
	domain-0.5.3
	dtoa-0.4.5
	fnv-1.0.6
	foreign-types-0.3.2
	foreign-types-shared-0.1.1
	fuchsia-zircon-0.3.3
	fuchsia-zircon-sys-0.3.3
	futures-channel-0.3.2
	futures-core-0.3.2
	futures-sink-0.3.2
	futures-task-0.3.2
	futures-util-0.3.2
	getrandom-0.1.14
	h2-0.2.1
	heck-0.3.1
	hermit-abi-0.1.6
	http-0.2.0
	httparse-1.3.4
	http-body-0.3.1
	hyper-0.13.2
	indexmap-1.3.1
	iovec-0.1.4
	itoa-0.4.5
	kernel32-sys-0.2.2
	lazy_static-1.4.0
	libc-0.2.66
	log-0.4.8
	memchr-2.3.0
	mio-0.6.21
	mio-uds-0.6.7
	miow-0.2.1
	net2-0.2.33
	num-traits-0.2.11
	openssl-0.10.27
	openssl-probe-0.1.2
	openssl-src-111.6.1+1.1.1d
	openssl-sys-0.9.54
	pin-project-0.4.8
	pin-project-internal-0.4.8
	pin-project-lite-0.1.4
	pin-utils-0.1.0-alpha.4
	pkg-config-0.3.17
	ppv-lite86-0.2.6
	proc-macro2-1.0.8
	proc-macro-error-0.4.8
	proc-macro-error-attr-0.4.8
	quote-1.0.2
	rand-0.7.3
	rand_chacha-0.2.1
	rand_core-0.5.1
	rand_hc-0.2.0
	redox_syscall-0.1.56
	remove_dir_all-0.5.2
	rustc-serialize-0.3.24
	rustversion-1.0.2
	schannel-0.1.17
	security-framework-0.3.4
	security-framework-sys-0.3.3
	signal-hook-registry-1.2.0
	simple_logger-1.5.0
	slab-0.4.2
	strsim-0.8.0
	structopt-0.3.9
	structopt-derive-0.4.2
	syn-1.0.14
	syn-mid-0.5.0
	tempfile-3.1.0
	textwrap-0.11.0
	time-0.1.42
	tokio-0.2.11
	tokio-macros-0.2.4
	tokio-tls-0.3.0
	tokio-util-0.2.0
	tower-service-0.3.0
	try-lock-0.2.2
	unicode-segmentation-1.6.0
	unicode-width-0.1.7
	unicode-xid-0.2.0
	vcpkg-0.2.8
	vec_map-0.8.1
	want-0.3.0
	wasi-0.9.0+wasi-snapshot-preview1
	winapi-0.2.8
	winapi-0.3.8
	winapi-build-0.1.1
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-x86_64-pc-windows-gnu-0.4.0
	ws2_32-sys-0.2.1
"

RUST_NATIVE_TLS_COMMIT="255dd5493b446755a9e40be3a4638afedfe67b03"
DESCRIPTION="Prometheus exporter for Unbound DNS resolver"
HOMEPAGE="https://github.com/svartalf/unbound-telemetry"
SRC_URI="
	https://github.com/svartalf/unbound-telemetry/archive/${COMMIT:-${PV}}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})
	https://github.com/Goirad/rust-native-tls/archive/${RUST_NATIVE_TLS_COMMIT}.tar.gz -> rust-native-tls-${RUST_NATIVE_TLS_COMMIT}.crate
"
S="${WORKDIR}/${PN}-${COMMIT:-${PV}}"

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD MIT Unlicense"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	acct-group/unbound-telemetry
	acct-user/unbound-telemetry
"

DOCS=(
	README.md
)

src_prepare() {
	# Ensure Cargo is satisfied with the manually downloaded rust-native-tls
	# Upstream use a fork *and* a certain branch
	sed -i -e '/pkcs8/d' Cargo.toml || die

	default
}

src_install() {
	cargo_src_install

	dodoc "${DOCS[@]}"
	newinitd "${FILESDIR}/initd" "${PN}"
	newconfd "${FILESDIR}/confd" "${PN}"
}
