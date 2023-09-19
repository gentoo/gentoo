# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	ansiterm@0.12.2
	anstream@0.5.0
	anstyle-parse@0.2.1
	anstyle-query@1.0.0
	anstyle-wincon@2.1.0
	anstyle@1.0.3
	autocfg@1.1.0
	bitflags@1.3.2
	bitflags@2.4.0
	bumpalo@3.13.0
	byteorder@1.4.3
	cc@1.0.79
	cfg-if@1.0.0
	chrono@0.4.30
	colorchoice@1.0.0
	content_inspector@0.2.4
	core-foundation-sys@0.8.4
	crossbeam-channel@0.5.8
	crossbeam-deque@0.8.3
	crossbeam-epoch@0.9.15
	crossbeam-utils@0.8.16
	datetime@0.5.2
	dunce@1.0.4
	either@1.9.0
	equivalent@1.0.1
	errno-dragonfly@0.1.2
	errno@0.3.3
	fastrand@2.0.0
	filetime@0.2.22
	form_urlencoded@1.0.1
	gethostname@0.4.3
	git2@0.18.0
	glob@0.3.1
	hashbrown@0.14.0
	hermit-abi@0.3.2
	humantime-serde@1.1.1
	humantime@2.1.0
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.57
	idna@0.2.3
	indexmap@2.0.0
	io-lifetimes@1.0.11
	jobserver@0.1.22
	js-sys@0.3.64
	lazy_static@1.4.0
	libc@0.2.147
	libgit2-sys@0.16.1+1.7.1
	libz-sys@1.1.2
	linux-raw-sys@0.3.8
	linux-raw-sys@0.4.7
	locale@0.2.2
	log@0.4.20
	matches@0.1.8
	memchr@2.6.3
	memoffset@0.9.0
	natord@1.0.9
	normalize-line-endings@0.3.0
	num-traits@0.2.14
	num_cpus@1.16.0
	number_prefix@0.4.0
	once_cell@1.18.0
	openssl-src@111.26.0+1.1.1u
	openssl-sys@0.9.61
	os_pipe@1.1.4
	partition-identity@0.3.0
	percent-encoding@2.1.0
	phf@0.11.2
	phf_generator@0.11.2
	phf_macros@0.11.2
	phf_shared@0.11.2
	pkg-config@0.3.19
	proc-macro2@1.0.66
	proc-mounts@0.3.0
	quote@1.0.33
	rand@0.8.5
	rand_core@0.6.4
	rayon-core@1.11.0
	rayon@1.7.0
	redox_syscall@0.1.57
	redox_syscall@0.3.5
	rustix@0.37.23
	rustix@0.38.13
	same-file@1.0.6
	scoped_threadpool@0.1.9
	scopeguard@1.2.0
	serde@1.0.188
	serde_derive@1.0.188
	serde_spanned@0.6.3
	shlex@1.2.0
	similar@2.2.1
	siphasher@0.3.11
	snapbox-macros@0.3.5
	snapbox@0.4.12
	syn@2.0.29
	tempfile@3.8.0
	term_grid@0.1.7
	terminal_size@0.2.6
	thiserror-impl@1.0.48
	thiserror@1.0.48
	timeago@0.4.1
	tinyvec@1.2.0
	tinyvec_macros@0.1.0
	toml_datetime@0.6.3
	toml_edit@0.19.15
	trycmd@0.14.17
	unicode-bidi@0.3.5
	unicode-ident@1.0.11
	unicode-normalization@0.1.17
	unicode-width@0.1.10
	url@2.2.1
	urlencoding@2.1.3
	utf8parse@0.2.1
	uzers@0.11.3
	vcpkg@0.2.12
	wait-timeout@0.2.0
	walkdir@2.4.0
	wasm-bindgen-backend@0.2.87
	wasm-bindgen-macro-support@0.2.87
	wasm-bindgen-macro@0.2.87
	wasm-bindgen-shared@0.2.87
	wasm-bindgen@0.2.87
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.5
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.48.0
	windows-targets@0.48.5
	windows@0.48.0
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_msvc@0.48.5
	windows_i686_gnu@0.48.5
	windows_i686_msvc@0.48.5
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_msvc@0.48.5
	winnow@0.5.15
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
LICENSE+=" Apache-2.0 MIT Unicode-DFS-2016"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="+git man"

DEPEND="git? ( dev-libs/libgit2:= )"
RDEPEND="${DEPEND}"
BDEPEND="
	>=virtual/rust-1.65.0
	man? ( virtual/pandoc )
"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_prepare() {
	default
	if use man; then
		mkdir -p contrib/man || die "failed to create man directory"
		pandoc --standalone -f markdown -t man man/eza.1.md \
			-o contrib/man/eza.1 || die "failed to create man page"
		pandoc --standalone -f markdown -t man man/eza_colors.5.md \
			-o contrib/man/eza_colors.5 || die "failed to create colors man page"
		pandoc --standalone -f markdown -t man man/eza_colors-explanation.5.md \
			-o contrib/man/eza_colors-explanation.5 || die "failed to create colors-explanation man page"
	fi

	# "source" files only, but cargo.eclass will attempt to install them.
	rm -r man || die "failed to remove man directory from source"

	sed -i -e 's/^strip = true$/strip = false/g' Cargo.toml || die "failed to disable stripping"
}

src_configure() {
	local myfeatures=(
		$(usev git)
	)
	export LIBGIT2_SYS_USE_PKG_CONFIG=1
	export PKG_CONFIG_ALLOW_CROSS=1
	cargo_src_configure --no-default-features
}

src_install() {
	cargo_src_install

	dobashcomp "completions/bash/${PN}"
	dozshcomp "completions/zsh/_${PN}"
	dofishcomp "completions/fish/${PN}.fish"

	if use man; then
		doman contrib/man/*
	fi
}
