# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.90.0"
CRATES="
	aho-corasick@1.1.5
	anstream@1.0.0
	anstyle-parse@1.0.0
	anstyle-query@1.1.5
	anstyle-wincon@3.0.11
	anstyle@1.0.14
	anyhow@1.0.104
	argmax@0.4.0
	bitflags@1.3.2
	bitflags@2.13.2
	block2@0.6.2
	bstr@1.13.1
	cc@1.10.0
	cfg-if@1.0.5
	cfg_aliases@0.2.2
	clap@4.6.7
	clap_builder@4.6.7
	clap_complete@4.6.11
	clap_derive@4.6.7
	clap_lex@1.1.1
	colorchoice@1.0.5
	crossbeam-channel@0.5.17
	crossbeam-deque@0.8.8
	crossbeam-epoch@0.9.21
	crossbeam-utils@0.8.23
	ctrlc@3.5.2
	defmt-macros@1.2.0
	defmt-parser@1.1.0
	defmt@1.2.0
	diff@0.1.13
	dispatch2@0.3.1
	errno@0.3.14
	etcetera@0.11.0
	faccess@0.2.4
	fastrand@2.5.0
	filetime@0.2.29
	find-msvc-tools@0.1.15
	getrandom@0.4.3
	globset@0.4.21
	heck@0.5.0
	ignore@0.4.34
	is_terminal_polyfill@1.70.2
	jiff-core@0.1.1
	jiff-static@0.2.38
	jiff-tzdb-platform@0.1.3
	jiff-tzdb@0.1.9
	jiff@0.2.38
	libc@0.2.191
	linux-raw-sys@0.12.1
	log@0.4.34
	lscolors@0.21.0
	memchr@2.8.3
	nix@0.30.1
	nix@0.31.3
	normpath@1.5.2
	nu-ansi-term@0.50.3
	objc2-encode@4.1.0
	objc2@0.6.5
	once_cell@1.21.4
	once_cell_polyfill@1.70.2
	portable-atomic-util@0.2.8
	portable-atomic@1.15.0
	proc-macro2@1.0.107
	quote@1.0.47
	r-efi@6.0.0
	regex-automata@0.4.18
	regex-syntax@0.8.11
	regex@1.13.1
	rustix@1.1.6
	same-file@1.0.6
	serde_core@1.0.229
	serde_derive@1.0.229
	shlex@2.0.1
	strsim@0.11.1
	syn@2.0.119
	syn@3.0.9
	tempfile@3.27.0
	terminal_size@0.4.4
	test-case-core@3.4.0
	test-case-macros@3.4.0
	test-case@3.4.0
	thiserror-impl@2.0.21
	thiserror@2.0.21
	tikv-jemalloc-sys@0.7.1+5.3.1-0-g81034ce1f1373e37dc865038e1bc8eeecf559ce8
	tikv-jemallocator@0.7.0
	unicode-ident@1.0.27
	utf8parse@0.2.2
	walkdir@2.5.0
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.11
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-link@0.2.1
	windows-sys@0.61.2
"

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
