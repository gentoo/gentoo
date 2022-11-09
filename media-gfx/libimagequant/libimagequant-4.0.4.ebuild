# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler-1.0.2
	ahash-0.7.6
	arrayvec-0.7.2
	autocfg-1.1.0
	bitflags-1.3.2
	bytemuck-1.12.1
	cc-1.0.73
	cfg-if-1.0.0
	crc32fast-1.3.2
	crossbeam-channel-0.5.6
	crossbeam-deque-0.8.2
	crossbeam-epoch-0.9.10
	crossbeam-utils-0.8.11
	either-1.8.0
	fallible_collections-0.4.5
	flate2-1.0.24
	getrandom-0.2.7
	hashbrown-0.12.3
	hermit-abi-0.1.19
	libc-0.2.132
	lodepng-3.7.0
	memoffset-0.6.5
	miniz_oxide-0.5.3
	noisy_float-0.2.0
	num_cpus-1.13.1
	num-traits-0.2.15
	once_cell-1.13.1
	rayon-1.5.3
	rayon-core-1.9.3
	rgb-0.8.33
	scopeguard-1.1.0
	thread_local-1.1.4
	version_check-0.9.4
	wasi-0.11.0+wasi-snapshot-preview1
"

inherit cargo

DESCRIPTION="Palette quantization library that powers pngquant and other PNG optimizers"
HOMEPAGE="https://pngquant.org/lib/"
SRC_URI="https://github.com/ImageOptim/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" $(cargo_crate_uris)"
S="${WORKDIR}"/${P}/imagequant-sys

LICENSE="GPL-3"
SLOT="0/0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc"

BDEPEND="
	>=dev-util/cargo-c-0.9.11
	>=virtual/rust-1.60
"

QA_FLAGS_IGNORED="usr/lib.*/libimagequant.so.*"

src_compile() {
	local cargoargs=(
		--library-type=cdylib
		--prefix=/usr
		--libdir="/usr/$(get_libdir)"
	)

	cargo cbuild "${cargoargs[@]}" || die "cargo cbuild failed"
}

src_install() {
	local cargoargs=(
		--library-type=cdylib
		--prefix=/usr
		--libdir="/usr/$(get_libdir)"
		--destdir="${ED}"
	)

	cargo cinstall "${cargoargs[@]}" || die "cargo cinstall failed"
}
