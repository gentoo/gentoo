# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.85.0"
CRATES="
	aho-corasick@1.1.3
	anyhow@1.0.100
	arbitrary@1.4.2
	bstr@1.12.0
	cc@1.2.41
	cfg-if@1.0.4
	crossbeam-channel@0.5.15
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.21
	derive_arbitrary@1.4.2
	encoding_rs@0.8.35
	encoding_rs_io@0.1.7
	find-msvc-tools@0.1.4
	getrandom@0.3.4
	glob@0.3.3
	itoa@1.0.15
	jobserver@0.1.34
	lexopt@0.3.1
	libc@0.2.177
	log@0.4.28
	memchr@2.7.6
	memmap2@0.9.8
	pcre2-sys@0.2.10
	pcre2@0.2.11
	pkg-config@0.3.32
	proc-macro2@1.0.101
	quote@1.0.41
	r-efi@5.3.0
	regex-automata@0.4.13
	regex-syntax@0.8.8
	regex@1.12.2
	ryu@1.0.20
	same-file@1.0.6
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.145
	shlex@1.3.0
	syn@2.0.106
	termcolor@1.4.1
	textwrap@0.16.2
	tikv-jemalloc-sys@0.6.0+5.3.0-1-ge13ca993e8ccb9ba9847cc330696e02839f328f7
	tikv-jemallocator@0.6.0
	unicode-ident@1.0.19
	walkdir@2.5.0
	wasip2@1.0.1+wasi-0.2.4
	winapi-util@0.1.11
	windows-link@0.2.1
	windows-sys@0.61.2
	wit-bindgen@0.46.0
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
LICENSE+="
	BSD MIT Unicode-3.0
	|| ( Apache-2.0 Boost-1.0 )
"
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
