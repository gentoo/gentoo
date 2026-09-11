# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.96.0"
CRATES=""
COMMIT=e02d242ecd54c5aea3ab63352e614c4c85bc97ac

inherit desktop cargo xdg

DESCRIPTION="Blazing-fast native Redis GUI built with Rust and GPUI"
HOMEPAGE="https://github.com/vicanso/zedis"
SRC_URI="https://github.com/vicanso/zedis/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-crate-dist/${PN}/releases/download/v${PV}/${P}-crates.tar.xz"

LICENSE="Apache-2.0"
# Dependent crate licenses
LICENSE+="
	0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD Boost-1.0
	CC0-1.0 CDLA-Permissive-2.0 ISC MIT MPL-2.0 UoI-NCSA Unicode-3.0
	ZLIB BZIP2
"
# ring crate
LICENSE+=" openssl"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	app-arch/zstd:=
	>=dev-libs/libgit2-1.9.7:=
	x11-libs/libxcb:=
	x11-libs/libxkbcommon[wayland,X]
"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	export ZSTD_SYS_USE_PKG_CONFIG=1
	export LIBGIT2_NO_VENDOR=1
	export VERGEN_GIT_SHA=${COMMIT}
}

src_install() {
	cargo_src_install
	domenu assets/zedis.desktop
	newicon assets/icon.png zedis.png
}
