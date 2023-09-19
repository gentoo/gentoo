# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ansi_term@0.12.1
	autocfg@1.1.0
	bitflags@1.3.2
	bitflags@2.4.0
	byteorder@1.4.3
	cc@1.0.79
	datetime@0.5.2
	errno@0.3.3
	errno-dragonfly@0.1.2
	form_urlencoded@1.0.1
	git2@0.18.0
	glob@0.3.1
	hermit-abi@0.3.2
	idna@0.2.3
	io-lifetimes@1.0.11
	jobserver@0.1.22
	lazy_static@1.4.0
	libc@0.2.147
	libgit2-sys@0.16.1+1.7.1
	libz-sys@1.1.2
	linux-raw-sys@0.3.8
	locale@0.2.2
	log@0.4.20
	matches@0.1.8
	natord@1.0.9
	num_cpus@1.16.0
	number_prefix@0.4.0
	openssl-src@111.26.0+1.1.1u
	openssl-sys@0.9.61
	pad@0.1.6
	percent-encoding@2.1.0
	phf@0.11.2
	phf_generator@0.11.2
	phf_macros@0.11.2
	phf_shared@0.11.2
	pkg-config@0.3.19
	proc-macro2@1.0.66
	quote@1.0.33
	rand@0.8.5
	rand_core@0.6.4
	redox_syscall@0.1.57
	rustix@0.37.23
	scoped_threadpool@0.1.9
	siphasher@0.3.11
	syn@2.0.29
	term_grid@0.1.7
	terminal_size@0.2.6
	timeago@0.4.1
	tinyvec@1.2.0
	tinyvec_macros@0.1.0
	unicode-bidi@0.3.5
	unicode-ident@1.0.11
	unicode-normalization@0.1.17
	unicode-width@0.1.10
	url@2.2.1
	uzers@0.11.2
	vcpkg@0.2.12
	winapi@0.3.9
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	windows-sys@0.48.0
	windows-targets@0.48.5
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_msvc@0.48.5
	windows_i686_gnu@0.48.5
	windows_i686_msvc@0.48.5
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_msvc@0.48.5
	zoneinfo_compiled@0.5.1
"

inherit shell-completion cargo

DESCRIPTION="A modern, maintained replacement for ls"
HOMEPAGE="https://github.com/eza-community/eza"
SRC_URI="https://github.com/eza-community/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" MIT Unicode-DFS-2016"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="+git man"

DEPEND="git? ( dev-libs/libgit2:= )"
RDEPEND="${DEPEND}"
BDEPEND="
	>=virtual/rust-1.70.0
	man? ( virtual/pandoc )
"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_prepare() {
	default
	if use man; then
		mkdir -p contrib/man || die "failed to create man directory"
		pandoc --standalone -f markdown -t man man/eza.1.md \
			-o contrib/man/eza.1 || die "failed to create man pages"
		pandoc --standalone -f markdown -t man man/eza_colors.5.md \
			-o contrib/man/eza_colors.5 || die "failed to create colored man pages"
		pandoc --standalone -f markdown -t man man/eza_colors-explanation.5.md \
			-o contrib/man/eza_colors-explanation.5 || die "failed to create colors-explanation man pages"
	fi

	# "source" files only, but cargo.eclass will attempt to install them.
	rm -r man || die "failed to remove man directory from source"

	sed -i -e 's/^strip = true$/strip = false/g' Cargo.toml || die "failed to disable stripping"
}

src_compile() {
	export LIBGIT2_SYS_USE_PKG_CONFIG=1
	export PKG_CONFIG_ALLOW_CROSS=1
	local myfeatures=(
		$(usev git)
	)
	cargo_src_compile --no-default-features
}

src_install() {
	cargo_src_install

	dobashcomp completions/bash/"${PN}"
	dozshcomp completions/zsh/_"${PN}"
	dofishcomp completions/fish/"${PN}".fish

	if use man; then
		doman contrib/man/*
	fi
}
