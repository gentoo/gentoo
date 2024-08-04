# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.3
	anes@0.1.6
	anstyle@1.0.8
	anyhow@1.0.86
	autocfg@1.3.0
	bitstream-io@2.5.0
	bitvec@1.0.1
	bitvec_helpers@3.1.5
	bumpalo@3.16.0
	cast@0.3.0
	cfg-if@1.0.0
	ciborium-io@0.2.2
	ciborium-ll@0.2.2
	ciborium@0.2.2
	clap@4.5.13
	clap_builder@4.5.13
	clap_lex@0.7.2
	crc-catalog@2.4.0
	crc@3.2.1
	criterion-plot@0.5.0
	criterion@0.5.1
	crossbeam-deque@0.8.5
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.20
	crunchy@0.2.2
	either@1.13.0
	equivalent@1.0.1
	funty@2.0.0
	half@2.4.1
	hashbrown@0.14.5
	hermit-abi@0.3.9
	indexmap@2.3.0
	is-terminal@0.4.12
	itertools@0.10.5
	itoa@1.0.11
	js-sys@0.3.69
	libc@0.2.155
	log@0.4.22
	memchr@2.7.4
	num-traits@0.2.19
	once_cell@1.19.0
	oorandom@11.1.4
	plotters-backend@0.3.6
	plotters-svg@0.3.6
	plotters@0.3.6
	proc-macro2@1.0.86
	quote@1.0.36
	radium@0.7.0
	rayon-core@1.12.1
	rayon@1.10.0
	regex-automata@0.4.7
	regex-syntax@0.8.4
	regex@1.10.6
	roxmltree@0.20.0
	ryu@1.0.18
	same-file@1.0.6
	serde@1.0.204
	serde_derive@1.0.204
	serde_json@1.0.122
	syn@2.0.72
	tap@1.0.1
	tinytemplate@1.2.1
	tinyvec@1.8.0
	unicode-ident@1.0.12
	walkdir@2.5.0
	wasm-bindgen-backend@0.2.92
	wasm-bindgen-macro-support@0.2.92
	wasm-bindgen-macro@0.2.92
	wasm-bindgen-shared@0.2.92
	wasm-bindgen@0.2.92
	web-sys@0.3.69
	winapi-util@0.1.9
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_msvc@0.52.6
	wyz@0.5.1
"
inherit cargo edo multilib-minimal rust-toolchain

DESCRIPTION="Dolby Vision metadata parsing and writing"
HOMEPAGE="https://github.com/quietvoid/dovi_tool/"
SRC_URI="
	https://github.com/quietvoid/dovi_tool/archive/refs/tags/${P}.tar.gz
	${CARGO_CRATE_URIS}
"
S=${WORKDIR}/dovi_tool-${P}/dolby_vision

LICENSE="MIT"
LICENSE+=" Apache-2.0 MIT Unicode-DFS-2016" # crates
SLOT="0/$(ver_cut 1)"
KEYWORDS="~amd64"

BDEPEND="
	dev-util/cargo-c
"

QA_FLAGS_IGNORED="usr/lib.*/${PN}.*"

src_prepare() {
	default

	multilib_copy_sources
}

multilib_src_configure() {
	local -n cargoargs=${PN}_CARGOARGS_${ABI}

	cargoargs=(
		--prefix="${EPREFIX}/usr"
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		--library-type=cdylib
		--target="$(rust_abi)"
		# cargo cbuild --help claims dev is default but (currently) this seems
		# to always use release unless --profile=dev is explicitly passed?
		$(usex debug --profile=dev --release)
	)
}

multilib_src_compile() {
	local -n cargoargs=${PN}_CARGOARGS_${ABI}

	edo cargo cbuild "${cargoargs[@]}"
}

multilib_src_install() {
	local -n cargoargs=${PN}_CARGOARGS_${ABI}

	edo cargo cinstall --destdir="${D}" "${cargoargs[@]}"
}
