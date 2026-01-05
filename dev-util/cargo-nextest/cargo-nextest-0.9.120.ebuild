# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""
RUST_MIN_VER="1.89.0"

inherit cargo

DESCRIPTION="Next-generation test runner for Rust"
HOMEPAGE="https://nexte.st/"
SRC_URI="
	https://github.com/nextest-rs/nextest/archive/refs/tags/${P}.tar.gz
	https://github.com/gentoo-crate-dist/nextest/releases/download/${P}/nextest-${P}-crates.tar.xz
"
S="${WORKDIR}"/nextest-${P}/${PN}

LICENSE="|| ( Apache-2.0 MIT )"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0
	CDLA-Permissive-2.0 ISC MIT MPL-2.0 Unicode-3.0 Unicode-DFS-2016
	WTFPL-2 ZLIB
"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

BDEPEND="virtual/pkgconfig"
DEPEND=">=app-arch/zstd-1.5.7:="
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED="usr/bin/${PN}"

pkg_setup() {
	export ZSTD_SYS_USE_PKG_CONFIG=1
	rust_pkg_setup
}

src_configure() {
	local myfeatures=( default-no-update )
	cargo_src_configure --no-default-features
}
