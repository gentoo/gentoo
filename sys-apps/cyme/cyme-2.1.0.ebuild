# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.3
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anstream@0.6.17
	anstyle-parse@0.2.6
	anstyle-query@1.1.2
	anstyle-wincon@3.0.6
	anstyle@1.0.9
	assert-json-diff@2.0.2
	atomic-polyfill@1.0.3
	atomic-waker@1.1.2
	autocfg@1.4.0
	base64@0.13.1
	bitflags@1.3.2
	bitflags@2.6.0
	bumpalo@3.16.0
	byteorder@1.5.0
	cc@1.1.31
	cfg-if@1.0.0
	chrono@0.4.38
	clap@4.5.20
	clap_builder@4.5.20
	clap_complete@4.5.36
	clap_derive@4.5.18
	clap_lex@0.7.2
	clap_mangen@0.2.24
	colorchoice@1.0.3
	colored@2.1.0
	core-foundation-sys@0.8.7
	core-foundation@0.9.4
	critical-section@1.2.0
	darling@0.20.10
	darling_core@0.20.10
	darling_macro@0.20.10
	deranged@0.3.11
	diff@0.1.13
	dirs-sys@0.3.7
	dirs@4.0.0
	either@1.13.0
	errno@0.3.9
	fnv@1.0.7
	futures-core@0.3.31
	getrandom@0.2.15
	glob@0.3.1
	hash32@0.2.1
	hashbrown@0.12.3
	heapless@0.7.17
	heck@0.4.1
	heck@0.5.0
	hermit-abi@0.3.9
	hex@0.4.3
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.61
	ident_case@1.0.1
	indexmap@1.9.3
	io-kit-sys@0.4.1
	io-lifetimes@1.0.11
	is_terminal_polyfill@1.70.1
	itertools@0.10.5
	itoa@1.0.11
	js-sys@0.3.72
	lazy_static@1.5.0
	libc@0.2.161
	libredox@0.1.3
	libudev-sys@0.1.4
	libusb1-sys@0.7.0
	linux-raw-sys@0.3.8
	linux-raw-sys@0.4.14
	lock_api@0.4.12
	log@0.4.22
	mach2@0.4.2
	memchr@2.7.4
	minimal-lexical@0.2.1
	nix@0.27.1
	nom@7.1.3
	num-conv@0.1.0
	num-traits@0.2.19
	num_threads@0.1.7
	once_cell@1.20.2
	pci-ids@0.2.5
	phf@0.11.2
	phf_codegen@0.11.2
	phf_generator@0.11.2
	phf_shared@0.11.2
	pkg-config@0.3.31
	powerfmt@0.2.0
	ppv-lite86@0.2.20
	proc-macro2@1.0.89
	quote@1.0.37
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	redox_users@0.4.6
	regex-automata@0.4.8
	regex-syntax@0.8.5
	regex@1.11.1
	roff@0.2.2
	rusb@0.9.4
	rustc_version@0.4.1
	rustix@0.37.27
	rustix@0.38.38
	rustversion@1.0.18
	ryu@1.0.18
	scopeguard@1.2.0
	semver@1.0.23
	serde@1.0.214
	serde_derive@1.0.214
	serde_json@1.0.132
	serde_with@2.3.3
	serde_with_macros@2.3.3
	shlex@1.3.0
	simple_logger@4.3.3
	siphasher@0.3.11
	slab@0.4.9
	spin@0.9.8
	stable_deref_trait@1.2.0
	strsim@0.11.1
	strum@0.26.3
	strum_macros@0.26.4
	syn@2.0.85
	terminal_size@0.2.6
	terminal_size@0.4.0
	thiserror-impl@1.0.65
	thiserror@1.0.65
	time-core@0.1.2
	time-macros@0.2.18
	time@0.3.36
	udev@0.8.0
	udevrs@0.3.0
	unicode-ident@1.0.13
	unicode-width@0.2.0
	usb-ids@1.2024.4
	utf8parse@0.2.2
	uuid@1.11.0
	vcpkg@0.2.15
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.95
	wasm-bindgen-macro-support@0.2.95
	wasm-bindgen-macro@0.2.95
	wasm-bindgen-shared@0.2.95
	wasm-bindgen@0.2.95
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.52.0
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-targets@0.48.5
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.6
	zerocopy-derive@0.7.35
	zerocopy@0.7.35
"

declare -A GIT_CRATES=(
	[nusb]='https://github.com/kevinmehall/nusb;b3097f552ab731fea0ecddd1598c91be75eef828;nusb-%commit%'
)

inherit cargo

DESCRIPTION="List system USB buses and devices; a modern cross-platform \`lsusb\`"
HOMEPAGE="https://github.com/tuna-f1sh/cyme/"
SRC_URI="
	https://github.com/tuna-f1sh/cyme/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="GPL-3+"
# Dependent crate licenses
LICENSE+="
	LGPL-2+ MIT MPL-2.0 Unicode-DFS-2016
	|| ( Apache-2.0 Boost-1.0 )
"
SLOT="0"
KEYWORDS="~amd64"

QA_FLAGS_IGNORED="/usr/bin/cyme"

src_prepare() {
	default

	# siiigh
	local nusb=( "${WORKDIR}"/nusb-* )
	sed -i -e "/^nusb/s&git.*&path = \"${nusb}/\" }&" Cargo.toml || die
}
