# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.0.5
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anes@0.1.6
	ansi_colours@1.2.2
	ansiterm@0.12.2
	anstream@0.6.4
	anstyle-parse@0.2.1
	anstyle-query@1.0.0
	anstyle-wincon@3.0.1
	anstyle@1.0.3
	approx@0.5.1
	autocfg@1.1.0
	bitflags@1.3.2
	bitflags@2.4.0
	bumpalo@3.13.0
	byteorder@1.4.3
	cast@0.3.0
	cc@1.0.79
	cfg-if@1.0.0
	chrono@0.4.31
	ciborium-io@0.2.1
	ciborium-ll@0.2.1
	ciborium@0.2.1
	clap@4.4.3
	clap_builder@4.4.2
	clap_lex@0.5.1
	colorchoice@1.0.0
	content_inspector@0.2.4
	core-foundation-sys@0.8.4
	criterion-plot@0.5.0
	criterion@0.5.1
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
	fast-srgb8@1.0.0
	fastrand@2.0.0
	filetime@0.2.22
	form_urlencoded@1.0.1
	git2@0.18.1
	glob@0.3.1
	half@1.8.2
	hashbrown@0.14.0
	hermit-abi@0.3.2
	humantime-serde@1.1.1
	humantime@2.1.0
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.57
	idna@0.2.3
	indexmap@2.0.0
	is-terminal@0.4.9
	itertools@0.10.5
	itoa@1.0.9
	jobserver@0.1.22
	js-sys@0.3.64
	libc@0.2.150
	libgit2-sys@0.16.1+1.7.1
	libz-sys@1.1.2
	linux-raw-sys@0.4.11
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
	oorandom@11.1.3
	openssl-src@111.26.0+1.1.1u
	openssl-sys@0.9.61
	os_pipe@1.1.4
	palette@0.7.3
	palette_derive@0.7.3
	partition-identity@0.3.0
	percent-encoding@2.3.0
	phf@0.11.2
	phf_generator@0.11.2
	phf_macros@0.11.2
	phf_shared@0.11.2
	pkg-config@0.3.19
	plotters-backend@0.3.5
	plotters-svg@0.3.5
	plotters@0.3.5
	proc-macro2@1.0.66
	proc-mounts@0.3.0
	quote@1.0.33
	rand@0.8.5
	rand_core@0.6.4
	rayon-core@1.11.0
	rayon@1.7.0
	redox_syscall@0.1.57
	redox_syscall@0.3.5
	regex-automata@0.3.8
	regex-syntax@0.7.5
	regex@1.9.5
	rustix@0.38.21
	ryu@1.0.15
	same-file@1.0.6
	scoped_threadpool@0.1.9
	scopeguard@1.2.0
	serde@1.0.188
	serde_derive@1.0.188
	serde_json@1.0.107
	serde_spanned@0.6.3
	shlex@1.2.0
	similar@2.2.1
	siphasher@0.3.11
	snapbox-macros@0.3.6
	snapbox@0.4.14
	syn@2.0.29
	tempfile@3.8.0
	terminal_size@0.3.0
	thiserror-impl@1.0.48
	thiserror@1.0.48
	timeago@0.4.2
	tinytemplate@1.2.1
	tinyvec@1.2.0
	tinyvec_macros@0.1.0
	toml_datetime@0.6.3
	toml_edit@0.20.1
	trycmd@0.14.19
	unicode-bidi@0.3.5
	unicode-ident@1.0.11
	unicode-normalization@0.1.17
	unicode-width@0.1.11
	url@2.2.1
	utf8parse@0.2.1
	uutils_term_grid@0.3.0
	uzers@0.11.3
	vcpkg@0.2.12
	wait-timeout@0.2.0
	walkdir@2.4.0
	wasm-bindgen-backend@0.2.87
	wasm-bindgen-macro-support@0.2.87
	wasm-bindgen-macro@0.2.87
	wasm-bindgen-shared@0.2.87
	wasm-bindgen@0.2.87
	web-sys@0.3.64
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

inherit cargo shell-completion

# script to generate the tarball: https://raw.githubusercontent.com/sevz17/eza-manpages/main/generate-eza-manpages
MANPAGES_BASE_URI="https://github.com/sevz17/eza-manpages/releases/download/${PV}"

DESCRIPTION="A modern, maintained replacement for ls"
HOMEPAGE="https://github.com/eza-community/eza"
SRC_URI="https://github.com/eza-community/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${MANPAGES_BASE_URI}/${P}-manpages.tar.xz
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0 LGPL-3+ MIT Unicode-DFS-2016"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="+git"

DEPEND="git? ( dev-libs/libgit2:= )"
RDEPEND="${DEPEND}"
BDEPEND=">=virtual/rust-1.70.0"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_prepare() {
	default

	# Known failing test, upstream says it could potentially be ignored for know
	# bug #914214
	# https://github.com/eza-community/eza/issues/393
	rm tests/cmd/{icons,basic}_all.toml || die
	rm tests/cmd/only_dir{,_recursive}_unix.toml || die
	rm tests/cmd/{recursive,only_file}_unix.toml || die

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

	doman "${WORKDIR}"/manpages/*
}

pkg_postinst() {
	for v in ${REPLACING_VERSIONS}; do
		if ver_test "${v}" -lt "0.13.0"; then
			elog "Starting with 0.13.0 \$EXA_COLORS using style codes nh and uh"
			elog "will need to be updated to use nt and ut"
		fi
	done
}
