# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick-0.7.19
	atty-0.2.14
	autocfg-1.1.0
	bindgen-0.60.1
	bitflags-1.3.2
	bytes-1.2.1
	cexpr-0.6.0
	cfg-if-1.0.0
	clang-sys-1.3.3
	clap-3.2.22
	clap_derive-3.2.18
	clap_lex-0.2.4
	either-1.8.0
	env_logger-0.9.1
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
	glob-0.3.0
	hashbrown-0.12.3
	heck-0.4.0
	hermit-abi-0.1.19
	humantime-2.1.0
	indexmap-1.9.1
	itoa-1.0.3
	lazy_static-1.4.0
	lazycell-1.3.0
	libc-0.2.132
	libloading-0.7.3
	lock_api-0.4.8
	log-0.4.17
	memchr-2.5.0
	minimal-lexical-0.2.1
	mio-0.8.4
	nom-7.1.1
	num_cpus-1.13.1
	once_cell-1.14.0
	os_str_bytes-6.3.0
	parking_lot-0.12.1
	parking_lot_core-0.9.3
	peeking_take_while-0.1.2
	pin-project-lite-0.2.9
	pin-utils-0.1.0
	pkg-config-0.3.25
	ppv-lite86-0.2.16
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.43
	quote-1.0.21
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.4
	redox_syscall-0.2.16
	regex-1.6.0
	regex-syntax-0.6.27
	retry-2.0.0
	rustc-hash-1.1.0
	ryu-1.0.11
	scopeguard-1.1.0
	serde-1.0.144
	serde_derive-1.0.144
	serde_json-1.0.85
	shlex-1.1.0
	signal-hook-registry-1.4.0
	slab-0.4.7
	smallvec-1.9.0
	socket2-0.4.7
	strsim-0.10.0
	syn-1.0.99
	termcolor-1.1.3
	textwrap-0.15.1
	thiserror-1.0.35
	thiserror-impl-1.0.35
	tokio-1.21.1
	tokio-macros-1.8.0
	tokio-stream-0.1.10
	toml-0.5.9
	unicode-ident-1.0.4
	version_check-0.9.4
	wasi-0.11.0+wasi-snapshot-preview1
	which-4.3.0
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

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/chenxiaolong/${PN}"
else
	SRC_URI="https://github.com/chenxiaolong/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		$(cargo_crate_uris)"
	# supported boards are x86_64 only, do not keyword elsewhere
	# technically it could run on remote host and issue commands via ipmitool lanplus, but that's very edgy case
	KEYWORDS="-* ~amd64"
fi

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 GPL-3+ ISC MIT Unicode-DFS-2016 Unlicense"
SLOT="0"

BDEPEND="
	sys-devel/clang
	virtual/pkgconfig
"

RDEPEND="sys-libs/freeipmi"
DEPEND="${RDEPEND}"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

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
