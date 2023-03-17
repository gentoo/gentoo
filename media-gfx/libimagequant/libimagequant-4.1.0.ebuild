# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
adler-1.0.2
ahash-0.7.6
arrayvec-0.7.2
autocfg-1.1.0
bitflags-1.3.2
bytemuck-1.13.0
cc-1.0.79
cfg-if-1.0.0
crc32fast-1.3.2
crossbeam-channel-0.5.6
crossbeam-deque-0.8.2
crossbeam-epoch-0.9.13
crossbeam-utils-0.8.14
either-1.8.1
fallible_collections-0.4.6
flate2-1.0.25
getrandom-0.2.8
hashbrown-0.12.3
hermit-abi-0.2.6
libc-0.2.139
lodepng-3.7.2
memoffset-0.7.1
miniz_oxide-0.6.2
noisy_float-0.2.0
num_cpus-1.15.0
num-traits-0.2.15
once_cell-1.17.0
rayon-1.6.1
rayon-core-1.10.2
rgb-0.8.34
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
KEYWORDS="~amd64 arm arm64 ppc ppc64 ~s390 ~sparc"

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
