# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line-0.17.0
	adler-1.0.2
	aho-corasick-0.7.19
	ansi_term-0.12.1
	atty-0.2.14
	autocfg-1.1.0
	backtrace-0.3.66
	bitflags-1.3.2
	bytes-1.2.1
	cc-1.0.73
	cfg-if-0.1.10
	cfg-if-1.0.0
	clap-2.34.0
	env_logger-0.9.0
	error-chain-0.12.4
	fastrand-1.8.0
	futures-0.3.24
	futures-channel-0.3.24
	futures-core-0.3.24
	futures-executor-0.3.24
	futures-io-0.3.24
	futures-macro-0.3.24
	futures-sink-0.3.24
	futures-task-0.3.24
	futures-util-0.3.24
	getrandom-0.2.7
	gimli-0.26.2
	heck-0.3.3
	hermit-abi-0.1.19
	humantime-2.1.0
	instant-0.1.12
	itoa-1.0.3
	lazy_static-1.4.0
	libc-0.2.132
	lock_api-0.4.8
	log-0.4.17
	memchr-2.5.0
	miniz_oxide-0.5.4
	mio-0.8.4
	nix-0.14.1
	num_cpus-1.13.1
	object-0.29.0
	once_cell-1.14.0
	parking_lot-0.12.1
	parking_lot_core-0.9.3
	pin-project-lite-0.2.9
	pin-utils-0.1.0
	ppv-lite86-0.2.16
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.43
	quote-1.0.21
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.3
	redox_syscall-0.2.16
	regex-1.6.0
	regex-syntax-0.6.27
	remove_dir_all-0.5.3
	retry-1.3.1
	rexpect-0.4.0
	rustc-demangle-0.1.21
	ryu-1.0.11
	scopeguard-1.1.0
	serde-1.0.144
	serde_derive-1.0.144
	serde_json-1.0.85
	signal-hook-registry-1.4.0
	slab-0.4.7
	smallvec-1.9.0
	socket2-0.4.7
	strsim-0.8.0
	structopt-0.3.26
	structopt-derive-0.4.18
	syn-1.0.99
	tempfile-3.3.0
	termcolor-1.1.3
	textwrap-0.11.0
	thiserror-1.0.35
	thiserror-impl-1.0.35
	tokio-1.21.1
	tokio-macros-1.8.0
	tokio-stream-0.1.9
	toml-0.5.9
	unicode-ident-1.0.3
	unicode-segmentation-1.10.0
	unicode-width-0.1.10
	vec_map-0.8.2
	version_check-0.9.4
	void-1.0.2
	wasi-0.11.0+wasi-snapshot-preview1
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.36.1
	windows_aarch64_msvc-0.36.1
	windows_i686_gnu-0.36.1
	windows_i686_msvc-0.36.1
	windows_x86_64_gnu-0.36.1
	windows_x86_64_msvc-0.36.1
"

inherit cargo optfeature systemd

DESCRIPTION="SuperMicro IPMI fan control daemon"
HOMEPAGE="https://github.com/chenxiaolong/ipmi-fan-control"
SRC_URI="https://github.com/chenxiaolong/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)
"

LICENSE="MIT 0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 GPL-3+ MIT Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0"
# supported boards are x86_64 only, do not keyword elsewhere
# technically it could run on remote host and issue commands via ipmitool lanplus, but that's very edgy case
KEYWORDS="-* ~amd64"

RDEPEND="sys-apps/ipmitool"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_install() {
	cargo_src_install

	sed -i \
		-e "s|@BINDIR@|${EPREFIX}/usr/bin|" \
		-e "s|@SYSCONFDIR@|${EPREFIX}/etc|" \
		dist/ipmi-fan-control.service.in || die

	# TODO: add openrc service
	systemd_newunit dist/ipmi-fan-control.service.in ipmi-fan-control.service

	insinto /etc
	newins config.sample.toml "${PN}".toml
}

pkg_postinst() {
	optfeature "S.M.A.R.T. drive temperature support" sys-apps/smartmontools
}
