# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.2
	anyhow@1.0.79
	autocfg@1.1.0
	bstr@1.9.0
	cc@1.0.83
	cfg-if@1.0.0
	crossbeam-channel@0.5.10
	crossbeam-deque@0.8.4
	crossbeam-epoch@0.9.17
	crossbeam-utils@0.8.18
	encoding_rs@0.8.33
	encoding_rs_io@0.1.7
	glob@0.3.1
	itoa@1.0.10
	jemalloc-sys@0.5.4+5.3.0-patched
	jemallocator@0.5.4
	jobserver@0.1.27
	lexopt@0.3.0
	libc@0.2.151
	libm@0.2.8
	log@0.4.20
	memchr@2.7.1
	memmap2@0.9.3
	num-traits@0.2.17
	packed_simd@0.3.9
	pcre2-sys@0.2.8
	pcre2@0.2.6
	pkg-config@0.3.28
	proc-macro2@1.0.76
	quote@1.0.35
	regex-automata@0.4.3
	regex-syntax@0.8.2
	regex@1.10.2
	ryu@1.0.16
	same-file@1.0.6
	serde@1.0.195
	serde_derive@1.0.195
	serde_json@1.0.111
	syn@2.0.48
	termcolor@1.4.0
	textwrap@0.16.0
	unicode-ident@1.0.12
	walkdir@2.4.0
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.6
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
"

inherit cargo bash-completion-r1

DESCRIPTION="Search tool that combines the usability of ag with the raw speed of grep"
HOMEPAGE="https://github.com/BurntSushi/ripgrep"
SRC_URI="
	https://github.com/BurntSushi/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="Apache-2.0"
# Dependent crate licenses
LICENSE+="
	BSD MIT Unicode-DFS-2016
	|| ( Apache-2.0 Boost-1.0 )
"
SLOT="0"
KEYWORDS="amd64 arm64 ~loong ppc64 ~riscv x86"
IUSE="+pcre"

RDEPEND="pcre? ( dev-libs/libpcre2:= )"
DEPEND="${RDEPEND}"
BDEPEND="
	>=virtual/rust-1.72
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

	newbashcomp - rg <<-EOF
	"$(cargo_target_dir)"/rg --generate complete-bash)
	EOF

	insinto /usr/share/fish/vendor_completions.d
	newins - rg.fish <<-EOF
	"$(cargo_target_dir)"/rg --generate complete-fish)
	EOF

	insinto /usr/share/zsh/site-functions
	newins - _rg <<-EOF
	"$(cargo_target_dir)"/rg --generate complete-zsh)
	EOF

	dodoc CHANGELOG.md FAQ.md GUIDE.md README.md
	newman - rg.1 <<-EOF
	"$(cargo_target_dir)"/rg --generate man)
	EOF
}
