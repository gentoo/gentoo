# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.96.0"
CRATES="
	aho-corasick@1.1.5
	anyhow@1.0.104
	arbitrary@1.5.0
	bstr@1.14.0
	cc@1.11.3
	cfg-if@1.0.5
	core_detect@1.0.0
	crossbeam-channel@0.5.17
	crossbeam-deque@0.8.8
	crossbeam-epoch@0.9.21
	crossbeam-utils@0.8.23
	derive_arbitrary@1.5.0
	encoding_rs@0.8.44
	encoding_rs_io@0.1.8
	find-msvc-tools@0.1.15
	getrandom@0.4.3
	glob@0.3.4
	itoa@1.0.19
	jobserver@0.1.35
	lexopt@0.3.2
	libc@0.2.191
	log@0.4.35
	memchr@2.8.3
	memmap2@0.9.12
	multiversion_no_op@1.0.0
	pcre2-sys@0.2.10
	pcre2@0.2.11
	pkg-config@0.3.34
	proc-macro2@1.0.107
	quote@1.0.47
	r-efi@6.0.0
	regex-automata@0.4.19
	regex-syntax@0.8.12
	regex@1.13.2
	rustversion@1.0.23
	same-file@1.0.6
	scopeguard@1.2.0
	serde@1.0.229
	serde_core@1.0.229
	serde_derive@1.0.229
	serde_json@1.0.154
	shlex@2.0.1
	simdutf8@0.1.5
	syn@3.0.10
	termcolor@1.4.1
	textwrap@0.16.4
	tikv-jemalloc-sys@0.7.1+5.3.1-0-g81034ce1f1373e37dc865038e1bc8eeecf559ce8
	tikv-jemallocator@0.7.0
	unicode-ident@1.0.27
	walkdir@2.5.1
	winapi-util@0.1.11
	windows-link@0.2.1
	windows-sys@0.61.2
	zmij@1.0.23
"

inherit cargo shell-completion

DESCRIPTION="Search tool that combines the usability of ag with the raw speed of grep"
HOMEPAGE="https://github.com/BurntSushi/ripgrep"
SRC_URI="
	https://github.com/BurntSushi/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="Apache-2.0"
# Dependent crate licenses
LICENSE+=" BSD MIT Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="+pcre"

RDEPEND="pcre? ( dev-libs/libpcre2:= )"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

QA_FLAGS_IGNORED="usr/bin/rg"

src_prepare() {
	default
	# unforce static linking on musl
	rm .cargo/config.toml || die
}

src_configure() {
	# allow building on musl with dynamic linking support
	# https://github.com/BurntSushi/rust-pcre2/issues/7
	use pcre && export PCRE2_SYS_STATIC=0
	myfeatures=( $(usev pcre pcre2) )
	cargo_src_configure
}

src_install() {
	cargo_src_install

	local gen=( "$(cargo_target_dir)"/rg --generate )
	newbashcomp - rg < <( "${gen[@]}" complete-bash || die )
	newfishcomp - rg.fish < <( "${gen[@]}" complete-fish || die )
	newzshcomp - _rg < <( "${gen[@]}" complete-zsh || die )

	dodoc CHANGELOG.md FAQ.md GUIDE.md README.md
	newman - rg.1 < <( "${gen[@]}" man || die )
}
