# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.3
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anstream@0.6.15
	anstyle-parse@0.2.5
	anstyle-query@1.1.1
	anstyle-wincon@3.0.4
	anstyle@1.0.8
	anyhow@1.0.86
	argmax@0.3.1
	autocfg@1.3.0
	bitflags@1.3.2
	bitflags@2.6.0
	bstr@1.10.0
	bumpalo@3.16.0
	cc@1.1.13
	cfg-if@1.0.0
	cfg_aliases@0.2.1
	chrono@0.4.38
	clap@4.5.16
	clap_builder@4.5.15
	clap_complete@4.5.19
	clap_derive@4.5.13
	clap_lex@0.7.2
	colorchoice@1.0.2
	core-foundation-sys@0.8.7
	crossbeam-channel@0.5.13
	crossbeam-deque@0.8.5
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.20
	ctrlc@3.4.5
	diff@0.1.13
	errno@0.3.9
	etcetera@0.8.0
	faccess@0.2.4
	fastrand@2.1.0
	filetime@0.2.24
	globset@0.4.14
	heck@0.5.0
	home@0.5.9
	humantime@2.1.0
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.60
	ignore@0.4.22
	is_terminal_polyfill@1.70.1
	jemalloc-sys@0.5.4+5.3.0-patched
	jemallocator@0.5.4
	js-sys@0.3.70
	lazy_static@1.5.0
	libc@0.2.158
	libredox@0.1.3
	linux-raw-sys@0.4.14
	log@0.4.22
	lscolors@0.19.0
	memchr@2.7.4
	nix@0.24.3
	nix@0.29.0
	normpath@1.3.0
	nu-ansi-term@0.50.1
	num-traits@0.2.19
	once_cell@1.19.0
	proc-macro2@1.0.86
	quote@1.0.36
	redox_syscall@0.5.3
	regex-automata@0.4.7
	regex-syntax@0.8.4
	regex@1.10.6
	rustix@0.38.34
	same-file@1.0.6
	serde@1.0.208
	serde_derive@1.0.208
	shlex@1.3.0
	strsim@0.11.1
	syn@2.0.75
	tempfile@3.12.0
	terminal_size@0.3.0
	test-case-core@3.3.1
	test-case-macros@3.3.1
	test-case@3.3.1
	unicode-ident@1.0.12
	utf8parse@0.2.2
	version_check@0.9.5
	walkdir@2.5.0
	wasm-bindgen-backend@0.2.93
	wasm-bindgen-macro-support@0.2.93
	wasm-bindgen-macro@0.2.93
	wasm-bindgen-shared@0.2.93
	wasm-bindgen@0.2.93
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.9
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
KEYWORDS="amd64 arm64 ppc64 x86"

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
