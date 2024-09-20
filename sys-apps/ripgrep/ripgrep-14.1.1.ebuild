# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.3
	anyhow@1.0.87
	bstr@1.10.0
	cc@1.1.18
	cfg-if@1.0.0
	crossbeam-channel@0.5.13
	crossbeam-deque@0.8.5
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.20
	encoding_rs@0.8.34
	encoding_rs_io@0.1.7
	glob@0.3.1
	itoa@1.0.11
	jemalloc-sys@0.5.4+5.3.0-patched
	jemallocator@0.5.4
	jobserver@0.1.32
	lexopt@0.3.0
	libc@0.2.158
	log@0.4.22
	memchr@2.7.4
	memmap2@0.9.4
	pcre2-sys@0.2.9
	pcre2@0.2.9
	pkg-config@0.3.30
	proc-macro2@1.0.86
	quote@1.0.37
	regex-automata@0.4.7
	regex-syntax@0.8.4
	regex@1.10.6
	ryu@1.0.18
	same-file@1.0.6
	serde@1.0.210
	serde_derive@1.0.210
	serde_json@1.0.128
	shlex@1.3.0
	syn@2.0.77
	termcolor@1.4.1
	textwrap@0.16.1
	unicode-ident@1.0.12
	walkdir@2.5.0
	winapi-util@0.1.9
	windows-sys@0.59.0
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
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
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
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

	local gen=( "$(cargo_target_dir)"/rg --generate )
	newbashcomp - rg < <( "${gen[@]}" complete-bash || die )

	insinto /usr/share/fish/vendor_completions.d
	newins - rg.fish < <( "${gen[@]}" complete-fish || die )

	insinto /usr/share/zsh/site-functions
	newins - _rg < <( "${gen[@]}" complete-zsh || die )

	dodoc CHANGELOG.md FAQ.md GUIDE.md README.md
	newman - rg.1 < <( "${gen[@]}" man || die )
}
