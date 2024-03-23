# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.2
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anstream@0.6.4
	anstyle-parse@0.2.2
	anstyle-query@1.0.0
	anstyle-wincon@3.0.1
	anstyle@1.0.4
	anyhow@1.0.75
	argmax@0.3.1
	autocfg@1.1.0
	bitflags@1.3.2
	bitflags@2.4.1
	bstr@1.7.0
	bumpalo@3.14.0
	cc@1.0.83
	cfg-if@1.0.0
	chrono@0.4.31
	clap@4.4.10
	clap_builder@4.4.9
	clap_complete@4.4.4
	clap_derive@4.4.7
	clap_lex@0.6.0
	colorchoice@1.0.0
	core-foundation-sys@0.8.4
	crossbeam-channel@0.5.8
	crossbeam-deque@0.8.3
	crossbeam-epoch@0.9.15
	crossbeam-utils@0.8.16
	ctrlc@3.4.1
	diff@0.1.13
	errno@0.3.5
	etcetera@0.8.0
	faccess@0.2.4
	fastrand@2.0.1
	filetime@0.2.22
	globset@0.4.14
	heck@0.4.1
	home@0.5.5
	humantime@2.1.0
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.58
	ignore@0.4.21
	jemalloc-sys@0.5.4+5.3.0-patched
	jemallocator@0.5.4
	js-sys@0.3.64
	lazy_static@1.4.0
	libc@0.2.150
	linux-raw-sys@0.4.10
	log@0.4.20
	lscolors@0.16.0
	memchr@2.6.4
	memoffset@0.9.0
	nix@0.24.3
	nix@0.27.1
	normpath@1.1.1
	nu-ansi-term@0.49.0
	num-traits@0.2.17
	once_cell@1.18.0
	proc-macro-error-attr@1.0.4
	proc-macro-error@1.0.4
	proc-macro2@1.0.69
	quote@1.0.33
	redox_syscall@0.3.5
	redox_syscall@0.4.1
	regex-automata@0.4.3
	regex-syntax@0.8.2
	regex@1.10.2
	rustix@0.38.21
	same-file@1.0.6
	scopeguard@1.2.0
	serde@1.0.189
	serde_derive@1.0.189
	strsim@0.10.0
	syn@1.0.109
	syn@2.0.38
	tempfile@3.8.1
	terminal_size@0.3.0
	test-case-core@3.2.1
	test-case-macros@3.2.1
	test-case@3.3.1
	unicode-ident@1.0.12
	utf8parse@0.2.1
	version_check@0.9.4
	walkdir@2.4.0
	wasm-bindgen-backend@0.2.87
	wasm-bindgen-macro-support@0.2.87
	wasm-bindgen-macro@0.2.87
	wasm-bindgen-shared@0.2.87
	wasm-bindgen@0.2.87
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.6
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.51.1
	windows-sys@0.48.0
	windows-targets@0.48.5
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_msvc@0.48.5
	windows_i686_gnu@0.48.5
	windows_i686_msvc@0.48.5
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_msvc@0.48.5
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

DEPEND="!elibc_musl? ( >=dev-libs/jemalloc-5.1.0:= )"
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED="/usr/bin/fd"

src_compile() {
	sed -i -e '/strip/d' Cargo.toml || die

	# this enables to build with system jemallloc, but musl targets do not use it at all
	if ! use elibc_musl; then
		export JEMALLOC_OVERRIDE="${ESYSROOT}/usr/$(get_libdir)/libjemalloc.so"
		export CARGO_FEATURE_UNPREFIXED_MALLOC_ON_SUPPORTED_PLATFORMS=1 # https://github.com/tikv/jemallocator/issues/19
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
