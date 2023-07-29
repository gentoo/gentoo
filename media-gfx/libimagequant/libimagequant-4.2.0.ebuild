# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
adler-1.0.2
ahash-0.8.3
arrayvec-0.7.2
autocfg-1.1.0
bitflags-1.3.2
bytemuck-1.13.1
cc-1.0.79
cfg-if-1.0.0
crc32fast-1.3.2
crossbeam-channel-0.5.8
crossbeam-deque-0.8.3
crossbeam-epoch-0.9.14
crossbeam-utils-0.8.15
either-1.8.1
fallible_collections-0.4.7
flate2-1.0.26
hashbrown-0.13.2
hermit-abi-0.2.6
libc-0.2.142
lodepng-3.7.2
memoffset-0.8.0
miniz_oxide-0.7.1
num_cpus-1.15.0
once_cell-1.17.1
rayon-1.7.0
rayon-core-1.11.0
rgb-0.8.36
scopeguard-1.1.0
thread_local-1.1.7
version_check-0.9.4
"

inherit cargo

DESCRIPTION="Palette quantization library that powers pngquant and other PNG optimizers"
HOMEPAGE="https://pngquant.org/lib/"
SRC_URI="https://github.com/ImageOptim/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" $(cargo_crate_uris)"
S="${WORKDIR}"/${P}/imagequant-sys

LICENSE="GPL-3"
SLOT="0/0"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~s390 sparc"

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
