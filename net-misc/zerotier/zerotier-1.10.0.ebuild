# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ansi_term-0.12.1
	atty-0.2.14
	autocfg-1.1.0
	base64-0.13.0
	bitflags-1.3.2
	block-buffer-0.10.2
	bumpalo-3.10.0
	bytes-1.1.0
	cbindgen-0.20.0
	cc-1.0.73
	cfg-if-1.0.0
	chrono-0.4.19
	clap-2.34.0
	core-foundation-0.9.3
	core-foundation-sys-0.8.3
	cpufeatures-0.2.2
	crypto-common-0.1.3
	digest-0.10.3
	either-1.6.1
	encoding_rs-0.8.31
	fastrand-1.7.0
	fnv-1.0.7
	foreign-types-0.3.2
	foreign-types-shared-0.1.1
	form_urlencoded-1.0.1
	futures-channel-0.3.21
	futures-core-0.3.21
	futures-io-0.3.21
	futures-sink-0.3.21
	futures-task-0.3.21
	futures-util-0.3.21
	generic-array-0.14.5
	getrandom-0.2.6
	h2-0.3.13
	hashbrown-0.11.2
	heck-0.3.3
	hermit-abi-0.1.19
	hmac-0.12.1
	http-0.2.8
	http-body-0.4.5
	httparse-1.7.1
	httpdate-1.0.2
	hyper-0.14.19
	hyper-tls-0.5.0
	idna-0.2.3
	indexmap-1.8.2
	instant-0.1.12
	ipnet-2.5.0
	itertools-0.10.3
	itoa-1.0.2
	js-sys-0.3.57
	jwt-0.16.0
	lazy_static-1.4.0
	libc-0.2.126
	log-0.4.17
	matches-0.1.9
	memchr-2.5.0
	mime-0.3.16
	mio-0.8.3
	native-tls-0.2.10
	num-bigint-0.4.3
	num-integer-0.1.45
	num-traits-0.2.15
	num_cpus-1.13.1
	num_threads-0.1.6
	oauth2-4.2.0
	once_cell-1.12.0
	openidconnect-2.3.1
	openssl-0.10.40
	openssl-macros-0.1.0
	openssl-probe-0.1.5
	openssl-sys-0.9.74
	ordered-float-2.10.0
	percent-encoding-2.1.0
	pin-project-lite-0.2.9
	pin-utils-0.1.0
	pkg-config-0.3.25
	ppv-lite86-0.2.16
	proc-macro2-1.0.39
	quote-1.0.18
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.3
	redox_syscall-0.2.13
	remove_dir_all-0.5.3
	reqwest-0.11.10
	ring-0.16.20
	ryu-1.0.10
	schannel-0.1.20
	security-framework-2.6.1
	security-framework-sys-2.6.1
	serde-1.0.137
	serde-value-0.7.0
	serde_derive-1.0.137
	serde_json-1.0.81
	serde_path_to_error-0.1.7
	serde_urlencoded-0.7.1
	sha2-0.10.2
	slab-0.4.6
	socket2-0.4.4
	spin-0.5.2
	strsim-0.8.0
	subtle-2.4.1
	syn-1.0.96
	tempfile-3.3.0
	textwrap-0.11.0
	thiserror-1.0.31
	thiserror-impl-1.0.31
	time-0.3.9
	tinyvec-1.6.0
	tinyvec_macros-0.1.0
	tokio-1.19.2
	tokio-native-tls-0.3.0
	tokio-util-0.7.3
	toml-0.5.9
	tower-service-0.3.1
	tracing-0.1.35
	tracing-core-0.1.27
	try-lock-0.2.3
	typenum-1.15.0
	unicode-bidi-0.3.8
	unicode-ident-1.0.0
	unicode-normalization-0.1.19
	unicode-segmentation-1.9.0
	unicode-width-0.1.9
	untrusted-0.7.1
	url-2.2.2
	vcpkg-0.2.15
	vec_map-0.8.2
	version_check-0.9.4
	want-0.3.0
	wasi-0.10.2+wasi-snapshot-preview1
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.80
	wasm-bindgen-backend-0.2.80
	wasm-bindgen-futures-0.4.30
	wasm-bindgen-macro-0.2.80
	wasm-bindgen-macro-support-0.2.80
	wasm-bindgen-shared-0.2.80
	web-sys-0.3.57
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.36.1
	windows_aarch64_msvc-0.36.1
	windows_i686_gnu-0.36.1
	windows_i686_msvc-0.36.1
	windows_x86_64_gnu-0.36.1
	windows_x86_64_msvc-0.36.1
	winreg-0.10.1
"

inherit flag-o-matic llvm systemd toolchain-funcs cargo

HOMEPAGE="https://www.zerotier.com/"
DESCRIPTION="A software-based managed Ethernet switch for planet Earth"
SRC_URI="
	https://github.com/zerotier/ZeroTierOne/archive/${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)
"

LICENSE="BSL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="clang cpu_flags_arm_neon"

S="${WORKDIR}/ZeroTierOne-${PV}"

RDEPEND="
	dev-libs/json-glib
	net-libs/libnatpmp
	net-libs/miniupnpc:="

DEPEND="${RDEPEND}"
BDEPEND="
	>=virtual/rust-1.53
	clang? (
		|| (
			sys-devel/clang:15
			sys-devel/clang:14
			sys-devel/clang:13
		)
	)"

PATCHES=(
	"${FILESDIR}/${PN}-1.10.1-respect-ldflags.patch"
)

DOCS=( README.md AUTHORS.md )

LLVM_MAX_SLOT=15

llvm_check_deps() {
	if use clang ; then
		if ! has_version -b "sys-devel/clang:${LLVM_SLOT}" ; then
			einfo "sys-devel/clang:${LLVM_SLOT} is missing! Cannot use LLVM slot ${LLVM_SLOT} ..."
			return 1
		fi

		einfo "Will use LLVM slot ${LLVM_SLOT}!"
	fi
}

pkg_setup() {
	if use clang && ! tc-is-clang ; then
		llvm_pkg_setup
		export CC=${CHOST}-clang
		export CXX=${CHOST}-clang++
	else
		tc-export CXX CC
	fi
	use cpu_flags_arm_neon || export ZT_DISABLE_NEON=1
}

src_compile() {
	append-ldflags -Wl,-z,noexecstack
	emake CXX="${CXX}" STRIP=: one
}

src_test() {
	emake selftest
	./zerotier-selftest || die
}

src_install() {
	default
	# remove pre-zipped man pages
	rm "${ED}"/usr/share/man/{man1,man8}/* || die

	newinitd "${FILESDIR}/${PN}".init-r1 "${PN}"
	systemd_dounit "${FILESDIR}/${PN}".service
	doman doc/zerotier-{cli.1,idtool.1,one.8}
}
