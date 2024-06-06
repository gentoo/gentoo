# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.3
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anstream@0.6.14
	anstyle-parse@0.2.4
	anstyle-query@1.0.3
	anstyle-wincon@3.0.3
	anstyle@1.0.7
	anyhow@1.0.82
	argmax@0.3.1
	autocfg@1.3.0
	bitflags@1.3.2
	bitflags@2.5.0
	bstr@1.9.1
	bumpalo@3.16.0
	cc@1.0.96
	cfg-if@1.0.0
	cfg_aliases@0.1.1
	chrono@0.4.38
	clap@4.5.4
	clap_builder@4.5.2
	clap_complete@4.5.2
	clap_derive@4.5.4
	clap_lex@0.7.0
	colorchoice@1.0.1
	core-foundation-sys@0.8.6
	crossbeam-channel@0.5.12
	crossbeam-deque@0.8.5
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.19
	ctrlc@3.4.4
	diff@0.1.13
	errno@0.3.8
	etcetera@0.8.0
	faccess@0.2.4
	fastrand@2.1.0
	filetime@0.2.23
	globset@0.4.14
	heck@0.5.0
	home@0.5.9
	humantime@2.1.0
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.60
	ignore@0.4.22
	is_terminal_polyfill@1.70.0
	jemalloc-sys@0.5.4+5.3.0-patched
	jemallocator@0.5.4
	js-sys@0.3.69
	lazy_static@1.4.0
	libc@0.2.154
	linux-raw-sys@0.4.13
	log@0.4.21
	lscolors@0.17.0
	memchr@2.7.2
	nix@0.24.3
	nix@0.28.0
	normpath@1.2.0
	nu-ansi-term@0.50.0
	num-traits@0.2.19
	once_cell@1.19.0
	proc-macro2@1.0.81
	quote@1.0.36
	redox_syscall@0.4.1
	regex-automata@0.4.6
	regex-syntax@0.8.3
	regex@1.10.4
	rustix@0.38.34
	same-file@1.0.6
	serde@1.0.200
	serde_derive@1.0.200
	strsim@0.11.1
	syn@2.0.60
	tempfile@3.10.1
	terminal_size@0.3.0
	test-case-core@3.3.1
	test-case-macros@3.3.1
	test-case@3.3.1
	unicode-ident@1.0.12
	utf8parse@0.2.1
	version_check@0.9.4
	walkdir@2.5.0
	wasm-bindgen-backend@0.2.92
	wasm-bindgen-macro-support@0.2.92
	wasm-bindgen-macro@0.2.92
	wasm-bindgen-shared@0.2.92
	wasm-bindgen@0.2.92
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.8
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.52.0
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-targets@0.48.5
	windows-targets@0.52.5
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.5
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.5
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.5
	windows_i686_gnullvm@0.52.5
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.5
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.5
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.5
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.5
"

inherit bash-completion-r1 cargo

DESCRIPTION="Alternative to find that provides sensible defaults for 80% of the use cases"
HOMEPAGE="https://github.com/sharkdp/fd"
SRC_URI="
	https://github.com/sharkdp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/sharkdp/${PN}/releases/download/v${PV}/${PN}-v${PV}-i686-unknown-linux-gnu.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="|| ( Apache-2.0 MIT )"
# Dependent crate licenses
LICENSE+=" MIT Unicode-DFS-2016"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

DEPEND="
	!elibc_musl? ( >=dev-libs/jemalloc-5.1.0:= )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=virtual/rust-1.77.2
"

QA_FLAGS_IGNORED="/usr/bin/fd"

src_compile() {
	sed -i -e '/strip/d' Cargo.toml || die

	# this enables to build with system jemallloc, but musl targets do not use it at all
	if ! use elibc_musl; then
		export JEMALLOC_OVERRIDE="${ESYSROOT}/usr/$(get_libdir)/libjemalloc.so"
		# https://github.com/tikv/jemallocator/issues/19
		export CARGO_FEATURE_UNPREFIXED_MALLOC_ON_SUPPORTED_PLATFORMS=1
	fi
	cargo_src_compile
}

src_test() {
	unset CLICOLOR_FORCE
	cargo_src_test
}

src_install() {
	cargo_src_install

	# pre-downloaded to avoid generation via running itself.
	local compdir="${WORKDIR}/${PN}-v${PV}-i686-unknown-linux-gnu"

	newbashcomp "${compdir}"/autocomplete/fd.bash fd

	insinto /usr/share/fish/vendor_completions.d
	doins "${compdir}"/autocomplete/fd.fish

	# zsh completion is in contrib
	insinto /usr/share/zsh/site-functions
	doins contrib/completion/_fd

	dodoc README.md
	doman doc/*.1
}
