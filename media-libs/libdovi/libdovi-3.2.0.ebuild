# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.2
	anes@0.1.6
	anstyle@1.0.6
	anyhow@1.0.80
	autocfg@1.1.0
	bitstream-io@2.2.0
	bitvec@1.0.1
	bitvec_helpers@3.1.3
	bumpalo@3.15.4
	cast@0.3.0
	cfg-if@1.0.0
	ciborium-io@0.2.2
	ciborium-ll@0.2.2
	ciborium@0.2.2
	clap@4.5.2
	clap_builder@4.5.2
	clap_lex@0.7.0
	crc-catalog@2.4.0
	crc@3.0.1
	criterion-plot@0.5.0
	criterion@0.5.1
	crossbeam-deque@0.8.5
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.19
	crunchy@0.2.2
	either@1.10.0
	equivalent@1.0.1
	funty@2.0.0
	half@2.4.0
	hashbrown@0.14.3
	hermit-abi@0.3.9
	indexmap@2.2.5
	is-terminal@0.4.12
	itertools@0.10.5
	itoa@1.0.10
	js-sys@0.3.69
	libc@0.2.153
	log@0.4.21
	memchr@2.7.1
	num-traits@0.2.18
	once_cell@1.19.0
	oorandom@11.1.3
	plotters-backend@0.3.5
	plotters-svg@0.3.5
	plotters@0.3.5
	proc-macro2@1.0.78
	quote@1.0.35
	radium@0.7.0
	rayon-core@1.12.1
	rayon@1.9.0
	regex-automata@0.4.6
	regex-syntax@0.8.2
	regex@1.10.3
	roxmltree@0.18.1
	ryu@1.0.17
	same-file@1.0.6
	serde@1.0.197
	serde_derive@1.0.197
	serde_json@1.0.114
	syn@2.0.52
	tap@1.0.1
	tinytemplate@1.2.1
	unicode-ident@1.0.12
	walkdir@2.5.0
	wasm-bindgen-backend@0.2.92
	wasm-bindgen-macro-support@0.2.92
	wasm-bindgen-macro@0.2.92
	wasm-bindgen-shared@0.2.92
	wasm-bindgen@0.2.92
	web-sys@0.3.69
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.6
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.52.0
	windows-targets@0.52.4
	windows_aarch64_gnullvm@0.52.4
	windows_aarch64_msvc@0.52.4
	windows_i686_gnu@0.52.4
	windows_i686_msvc@0.52.4
	windows_x86_64_gnullvm@0.52.4
	windows_x86_64_gnu@0.52.4
	windows_x86_64_msvc@0.52.4
	wyz@0.5.1
	xmlparser@0.13.6
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
