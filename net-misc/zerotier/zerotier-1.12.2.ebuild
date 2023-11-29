# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CARGO_OPTIONAL=1

CRATES="
	addr2line@0.20.0
	adler@1.0.2
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	ansi_term@0.12.1
	atty@0.2.14
	autocfg@1.1.0
	backtrace@0.3.68
	base64@0.13.1
	base64@0.21.2
	bitflags@1.3.2
	bitflags@2.4.0
	block-buffer@0.10.4
	bumpalo@3.13.0
	bytes@1.4.0
	cbindgen@0.20.0
	cc@1.0.82
	cfg-if@1.0.0
	chrono@0.4.26
	clap@2.34.0
	core-foundation-sys@0.8.4
	core-foundation@0.9.3
	cpufeatures@0.2.9
	crypto-common@0.1.6
	darling@0.13.4
	darling_core@0.13.4
	darling_macro@0.13.4
	deranged@0.3.7
	digest@0.10.7
	either@1.9.0
	encoding_rs@0.8.32
	errno-dragonfly@0.1.2
	errno@0.3.2
	fastrand@2.0.0
	fnv@1.0.7
	foreign-types-shared@0.1.1
	foreign-types@0.3.2
	form_urlencoded@1.2.0
	futures-channel@0.3.28
	futures-core@0.3.28
	futures-io@0.3.28
	futures-sink@0.3.28
	futures-task@0.3.28
	futures-util@0.3.28
	generic-array@0.14.7
	getrandom@0.2.10
	gimli@0.27.3
	h2@0.3.20
	hashbrown@0.12.3
	heck@0.3.3
	hermit-abi@0.1.19
	hermit-abi@0.3.2
	hmac@0.12.1
	http-body@0.4.5
	http@0.2.9
	httparse@1.8.0
	httpdate@1.0.3
	hyper-tls@0.5.0
	hyper@0.14.27
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.57
	ident_case@1.0.1
	idna@0.4.0
	indexmap@1.9.3
	ipnet@2.8.0
	itertools@0.10.5
	itoa@1.0.9
	js-sys@0.3.64
	lazy_static@1.4.0
	libc@0.2.147
	linux-raw-sys@0.4.5
	log@0.4.20
	memchr@2.5.0
	mime@0.3.17
	miniz_oxide@0.7.1
	mio@0.8.8
	native-tls@0.2.11
	num-bigint@0.4.3
	num-integer@0.1.45
	num-traits@0.2.16
	num_cpus@1.16.0
	oauth2@4.4.1
	object@0.31.1
	once_cell@1.18.0
	openidconnect@2.5.1
	openssl-macros@0.1.1
	openssl-probe@0.1.5
	openssl-sys@0.9.91
	openssl@0.10.56
	ordered-float@2.10.0
	percent-encoding@2.3.0
	pin-project-lite@0.2.12
	pin-utils@0.1.0
	pkg-config@0.3.27
	ppv-lite86@0.2.17
	proc-macro2@1.0.66
	quote@1.0.33
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	redox_syscall@0.3.5
	reqwest@0.11.18
	ring@0.16.20
	rustc-demangle@0.1.23
	rustix@0.38.8
	ryu@1.0.15
	schannel@0.1.22
	security-framework-sys@2.9.1
	security-framework@2.9.2
	serde-value@0.7.0
	serde@1.0.183
	serde_derive@1.0.183
	serde_json@1.0.105
	serde_path_to_error@0.1.14
	serde_plain@1.0.1
	serde_urlencoded@0.7.1
	serde_with@1.14.0
	serde_with_macros@1.5.2
	sha2@0.10.7
	slab@0.4.8
	socket2@0.4.9
	socket2@0.5.3
	spin@0.5.2
	strsim@0.10.0
	strsim@0.8.0
	subtle@2.5.0
	syn@1.0.109
	syn@2.0.29
	tempfile@3.7.1
	textwrap@0.11.0
	thiserror-impl@1.0.47
	thiserror@1.0.47
	time-core@0.1.1
	time-macros@0.2.11
	time@0.3.25
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	tokio-native-tls@0.3.1
	tokio-util@0.7.8
	tokio@1.32.0
	toml@0.5.11
	tower-service@0.3.2
	tracing-core@0.1.31
	tracing@0.1.37
	try-lock@0.2.4
	typenum@1.16.0
	unicode-bidi@0.3.13
	unicode-ident@1.0.11
	unicode-normalization@0.1.22
	unicode-segmentation@1.10.1
	unicode-width@0.1.10
	untrusted@0.7.1
	url@2.4.0
	vcpkg@0.2.15
	vec_map@0.8.2
	version_check@0.9.4
	want@0.3.1
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.87
	wasm-bindgen-futures@0.4.37
	wasm-bindgen-macro-support@0.2.87
	wasm-bindgen-macro@0.2.87
	wasm-bindgen-shared@0.2.87
	wasm-bindgen@0.2.87
	web-sys@0.3.64
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.48.0
	windows-targets@0.48.5
	windows@0.48.0
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_msvc@0.48.5
	windows_i686_gnu@0.48.5
	windows_i686_msvc@0.48.5
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_msvc@0.48.5
	winreg@0.10.1
"

declare -A GIT_CRATES=(
	[jwt]='https://github.com/glimberg/rust-jwt;61a9291fdeec747c6edf14f4fa0caf235136c168;rust-jwt-%commit%'
)

inherit cargo systemd toolchain-funcs

DESCRIPTION="A software-based managed Ethernet switch for planet Earth"
HOMEPAGE="https://www.zerotier.com/"
SRC_URI="
	https://github.com/zerotier/ZeroTierOne/archive/${PV}.tar.gz -> ${P}.tar.gz
	sso? (
		${CARGO_CRATE_URIS}
	)
"
S="${WORKDIR}"/ZeroTierOne-${PV}

LICENSE="BUSL-1.1"
# Crate licenses
LICENSE+=" sso? ( Apache-2.0 BSD ISC MIT MPL-2.0 Unicode-DFS-2016 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="cpu_flags_arm_neon debug sso"

RDEPEND="
	dev-libs/openssl:=
	net-libs/libnatpmp
	>=net-libs/miniupnpc-2:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	sso? (
		virtual/rust
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.10.1-respect-ldflags.patch
	"${FILESDIR}"/${PN}-1.10.1-add-armv7a-support.patch
	"${FILESDIR}"/${PN}-1.12.2-noexecstack.patch
)

DOCS=( README.md AUTHORS.md )

src_unpack() {
	unpack ${P}.tar.gz
	use sso && cargo_src_unpack
}

src_prepare() {
	default

	#1. Dont call cargo, we'll run it with cargo eclass functions
	#2. Remove man page compression and install, we'll handle it with ebuild functions
	sed -i \
		-e '/ifeq ($(ZT_SSO_SUPPORTED)/,/endif/ { /cargo build/d }' \
		-e '/install:/,/^$/ { /man[0-9]/d }' \
		make-linux.mk || die
}

src_configure() {
	tc-export CXX CC

	use cpu_flags_arm_neon || export ZT_DISABLE_NEON=1

	use sso && cargo_src_configure
}

src_compile() {
	myemakeargs=(
		CXX="${CXX}"
		STRIP=:

		# Debug doesnt do more than add preprocessor arguments normally,
		# but when rust is used it sets the correct rust directory to link against.
		# It would be added by cargo eclass eitherway, so instead of adding REQUIRED_USE
		# and patching the makefile its just easier to have it.
		ZT_DEBUG="$(usex debug 1 0)"
		ZT_SSO_SUPPORTED="$(usex sso 1 0)"
	)

	pushd zeroidc > /dev/null || die
	use sso && cargo_src_compile
	popd > /dev/null || die

	emake "${myemakeargs[@]}" one
}

src_test() {
	emake "${myemakeargs[@]}" selftest
	./zerotier-selftest || die
}

src_install() {
	default

	newinitd "${FILESDIR}/${PN}".init-r1 "${PN}"
	systemd_dounit "${FILESDIR}/${PN}".service

	doman doc/zerotier-{cli.1,idtool.1,one.8}
}
