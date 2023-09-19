# Copyright 2017-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Only bother defining this if the github tarball doesn't work!
# Otherwise just comment it out and things should Just Work (TM).
#MY_P="${P}+cargo-{CARGO_V}"

CRATES="
	${MY_P}
	adler-1.0.2
	aho-corasick-0.7.19
	anyhow-1.0.66
	arrayvec-0.5.2
	atty-0.2.14
	autocfg-1.1.0
	bitflags-1.3.2
	bitmaps-2.1.0
	bstr-0.2.17
	bytes-1.2.1
	bytesize-1.1.0
	cargo-0.66.0
	cargo-platform-0.1.2
	cargo-util-0.2.2
	cbindgen-0.24.3
	cc-1.0.76
	cfg-if-1.0.0
	clap-3.2.23
	clap_derive-3.2.18
	clap_lex-0.2.4
	combine-4.6.6
	commoncrypto-0.2.0
	commoncrypto-sys-0.2.0
	core-foundation-0.9.3
	core-foundation-sys-0.8.3
	crates-io-0.34.0
	crc32fast-1.3.2
	crossbeam-utils-0.8.12
	crypto-hash-0.3.4
	curl-0.4.44
	curl-sys-0.4.59+curl-7.86.0
	either-1.8.0
	env_logger-0.9.3
	fastrand-1.8.0
	filetime-0.2.18
	flate2-1.0.24
	fnv-1.0.7
	foreign-types-0.3.2
	foreign-types-shared-0.1.1
	form_urlencoded-1.1.0
	fwdansi-1.1.0
	git2-0.15.0
	git2-curl-0.16.0
	glob-0.3.0
	globset-0.4.9
	hashbrown-0.12.3
	heck-0.4.0
	hermit-abi-0.1.19
	hex-0.3.2
	hex-0.4.3
	home-0.5.4
	humantime-2.1.0
	idna-0.3.0
	ignore-0.4.18
	im-rc-15.1.0
	indexmap-1.9.2
	instant-0.1.12
	itertools-0.10.5
	itoa-1.0.4
	jobserver-0.1.25
	kstring-2.0.0
	lazycell-1.3.0
	lazy_static-1.4.0
	libc-0.2.137
	libgit2-sys-0.14.0+1.5.0
	libnghttp2-sys-0.1.7+1.45.0
	libssh2-sys-0.2.23
	libz-sys-1.1.8
	log-0.4.17
	memchr-2.5.0
	miniz_oxide-0.5.4
	miow-0.3.7
	once_cell-1.16.0
	opener-0.5.0
	openssl-0.10.42
	openssl-macros-0.1.0
	openssl-probe-0.1.5
	openssl-src-111.24.0+1.1.1s
	openssl-sys-0.9.77
	os_info-3.5.1
	os_str_bytes-6.4.1
	pathdiff-0.2.1
	percent-encoding-2.2.0
	pkg-config-0.3.26
	proc-macro2-1.0.47
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	quote-1.0.21
	rand_core-0.6.4
	rand_xoshiro-0.6.0
	redox_syscall-0.2.16
	regex-1.7.0
	regex-automata-0.1.10
	regex-syntax-0.6.28
	remove_dir_all-0.5.3
	rustc-workspace-hack-1.0.0
	rustfix-0.6.1
	ryu-1.0.11
	same-file-1.0.6
	schannel-0.1.20
	semver-1.0.14
	serde-1.0.147
	serde_derive-1.0.147
	serde_ignored-0.1.5
	serde_json-1.0.87
	shell-escape-0.1.5
	sized-chunks-0.6.5
	socket2-0.4.7
	static_assertions-1.1.0
	strip-ansi-escapes-0.1.1
	strsim-0.10.0
	syn-1.0.103
	tar-0.4.38
	tempfile-3.3.0
	termcolor-1.1.3
	textwrap-0.16.0
	thread_local-1.1.4
	tinyvec-1.6.0
	tinyvec_macros-0.1.0
	toml-0.5.9
	toml_edit-0.14.4
	typenum-1.15.0
	unicode-bidi-0.3.8
	unicode-ident-1.0.5
	unicode-normalization-0.1.22
	unicode-width-0.1.10
	unicode-xid-0.2.4
	url-2.3.1
	utf8parse-0.2.0
	vcpkg-0.2.15
	version_check-0.9.4
	vte-0.10.1
	vte_generate_state_changes-0.1.1
	walkdir-2.3.2
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows_aarch64_gnullvm-0.42.0
	windows_aarch64_msvc-0.36.1
	windows_aarch64_msvc-0.42.0
	windows_i686_gnu-0.36.1
	windows_i686_gnu-0.42.0
	windows_i686_msvc-0.36.1
	windows_i686_msvc-0.42.0
	windows-sys-0.36.1
	windows-sys-0.42.0
	windows_x86_64_gnu-0.36.1
	windows_x86_64_gnu-0.42.0
	windows_x86_64_gnullvm-0.42.0
	windows_x86_64_msvc-0.36.1
	windows_x86_64_msvc-0.42.0
"

inherit cargo

DESCRIPTION="Helper program to build and install c-like libraries"
HOMEPAGE="https://github.com/lu-zero/cargo-c"
if [[ -z ${MY_P} ]] ; then
	SRC_URI="https://github.com/lu-zero/cargo-c/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
else
	S="${WORKDIR}/${MY_P}"
fi

SRC_URI+=" $(cargo_crate_uris)"

LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions Boost-1.0 MIT MPL-2.0 Unlicense ZLIB"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="dev-libs/libgit2:=
	dev-libs/openssl:=
	net-libs/libssh2:=
	net-misc/curl[ssl]
	sys-libs/zlib"
DEPEND="${RDEPEND}"
BDEPEND=">=virtual/rust-1.65.0"

QA_FLAGS_IGNORED="usr/bin/cargo-capi usr/bin/cargo-cbuild usr/bin/cargo-ctest usr/bin/cargo-cinstall"

src_unpack() {
	cargo_src_unpack

	if [[ -n ${MY_P} ]] ; then
		tar -xf "${DISTDIR}"/"${MY_P}.crate" -C "${WORKDIR}" || die
	fi
}

src_configure() {
	# Some crates will auto-build and statically link C libraries(!)
	# Tracker bug #709568
	export LIBSSH2_SYS_USE_PKG_CONFIG=1
	export LIBGIT2_SYS_USE_PKG_CONFIG=1
	export PKG_CONFIG_ALLOW_CROSS=1
}
