# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.3
	anstream@0.6.19
	anstyle-parse@0.2.7
	anstyle-query@1.1.3
	anstyle-wincon@3.0.9
	anstyle@1.0.11
	anyhow@1.0.98
	argmax@0.4.0
	bitflags@1.3.2
	bitflags@2.9.1
	bstr@1.12.0
	cc@1.2.29
	cfg-if@1.0.1
	cfg_aliases@0.2.1
	clap@4.5.42
	clap_builder@4.5.42
	clap_complete@4.5.55
	clap_derive@4.5.41
	clap_lex@0.7.5
	colorchoice@1.0.4
	crossbeam-channel@0.5.15
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.21
	ctrlc@3.4.7
	diff@0.1.13
	errno@0.3.13
	etcetera@0.10.0
	faccess@0.2.4
	fastrand@2.3.0
	filetime@0.2.25
	getrandom@0.3.3
	globset@0.4.16
	heck@0.5.0
	home@0.5.9
	ignore@0.4.23
	is_terminal_polyfill@1.70.1
	jiff-static@0.2.15
	jiff-tzdb-platform@0.1.3
	jiff-tzdb@0.1.4
	jiff@0.2.15
	libc@0.2.174
	libredox@0.1.4
	linux-raw-sys@0.9.4
	log@0.4.27
	lscolors@0.20.0
	memchr@2.7.5
	nix@0.30.1
	normpath@1.3.0
	nu-ansi-term@0.50.1
	once_cell@1.21.3
	once_cell_polyfill@1.70.1
	portable-atomic-util@0.2.4
	portable-atomic@1.11.1
	proc-macro2@1.0.95
	quote@1.0.40
	r-efi@5.3.0
	redox_syscall@0.5.13
	regex-automata@0.4.9
	regex-syntax@0.8.5
	regex@1.11.1
	rustix@1.0.7
	same-file@1.0.6
	serde@1.0.219
	serde_derive@1.0.219
	shlex@1.3.0
	strsim@0.11.1
	syn@2.0.104
	tempfile@3.20.0
	terminal_size@0.4.2
	test-case-core@3.3.1
	test-case-macros@3.3.1
	test-case@3.3.1
	tikv-jemalloc-sys@0.6.0+5.3.0-1-ge13ca993e8ccb9ba9847cc330696e02839f328f7
	tikv-jemallocator@0.6.0
	unicode-ident@1.0.18
	utf8parse@0.2.2
	version_check@0.9.5
	walkdir@2.5.0
	wasi@0.14.2+wasi-0.2.4
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.9
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-sys@0.60.2
	windows-targets@0.52.6
	windows-targets@0.53.2
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_gnullvm@0.53.0
	windows_aarch64_msvc@0.52.6
	windows_aarch64_msvc@0.53.0
	windows_i686_gnu@0.52.6
	windows_i686_gnu@0.53.0
	windows_i686_gnullvm@0.52.6
	windows_i686_gnullvm@0.53.0
	windows_i686_msvc@0.52.6
	windows_i686_msvc@0.53.0
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnu@0.53.0
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_gnullvm@0.53.0
	windows_x86_64_msvc@0.52.6
	windows_x86_64_msvc@0.53.0
	wit-bindgen-rt@0.39.0
"

RUST_MIN_VER="1.79.0"

inherit cargo shell-completion

DESCRIPTION="Alternative to find that provides sensible defaults for 80% of the use cases"
HOMEPAGE="https://github.com/sharkdp/fd"
SRC_URI="
	https://github.com/sharkdp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/sharkdp/${PN}/releases/download/v${PV}/${PN}-v${PV}-i686-unknown-linux-gnu.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="|| ( Apache-2.0 MIT )"
# Dependent crate licenses
LICENSE+=" MIT Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

DEPEND="
	!elibc_musl? ( >=dev-libs/jemalloc-5.1.0:= )
"
RDEPEND="
	${DEPEND}
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
	dofishcomp "${compdir}"/autocomplete/fd.fish
	# zsh completion is in contrib
	dozshcomp contrib/completion/_fd

	dodoc README.md
	doman doc/*.1
}
