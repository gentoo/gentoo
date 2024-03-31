# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"

inherit cargo

DESCRIPTION="Palette quantization library that powers pngquant and other PNG optimizers"
HOMEPAGE="https://pngquant.org/lib/"
SRC_URI="https://github.com/ImageOptim/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
	https://dev.gentoo.org/~arthurzam/distfiles/media-gfx/${PN}/imagequant-${PV}-crates.tar.xz"
S="${WORKDIR}"/${P}/imagequant-sys

LICENSE="GPL-3+"
# Dependent crate licenses
LICENSE+=" MIT Unicode-DFS-2016 ZLIB"
SLOT="0/0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~s390 ~sparc"

BDEPEND="
	>=dev-util/cargo-c-0.9.14
	>=virtual/rust-1.64
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
