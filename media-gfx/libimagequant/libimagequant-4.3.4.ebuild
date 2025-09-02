# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler2@2.0.0
	arrayvec@0.7.6
	bitflags@2.8.0
	bytemuck@1.21.0
	cc@1.2.13
	cfg-if@1.0.0
	crc32fast@1.4.2
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.21
	either@1.13.0
	flate2@1.0.35
	libc@0.2.169
	lodepng@3.11.0
	miniz_oxide@0.8.3
	once_cell@1.20.3
	rayon-core@1.12.1
	rayon@1.10.0
	rgb@0.8.50
	shlex@1.3.0
	thread_local@1.1.8
"

inherit cargo

DESCRIPTION="Palette quantization library that powers pngquant and other PNG optimizers"
HOMEPAGE="https://pngquant.org/lib/"
SRC_URI="https://github.com/ImageOptim/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}"
S="${WORKDIR}"/${P}/imagequant-sys

LICENSE="GPL-3+"
# Dependent crate licenses
LICENSE+=" MIT ZLIB"
SLOT="0/0"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~s390 ~sparc"

BDEPEND="
	>=dev-util/cargo-c-0.9.14
"

QA_FLAGS_IGNORED="usr/lib.*/libimagequant.so.*"

src_compile() {
	local cargoargs=(
		--library-type=cdylib
		--prefix=/usr
		--libdir="/usr/$(get_libdir)"
		$(usev !debug '--release')
	)

	cargo cbuild "${cargoargs[@]}" || die "cargo cbuild failed"
}

src_install() {
	local cargoargs=(
		--library-type=cdylib
		--prefix=/usr
		--libdir="/usr/$(get_libdir)"
		--destdir="${ED}"
		$(usex debug '--debug' '--release')
	)

	cargo cinstall "${cargoargs[@]}" || die "cargo cinstall failed"
}
