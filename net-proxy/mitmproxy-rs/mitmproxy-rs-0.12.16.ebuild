# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{12..15} )
RUST_MIN_VER=1.95.0

inherit cargo distutils-r1 pypi

DESCRIPTION="mitmproxy's Rust bits"
HOMEPAGE="
	https://github.com/mitmproxy/mitmproxy_rs/
	https://pypi.org/project/mitmproxy-rs/
"
SRC_URI+="
	${CARGO_CRATE_URIS}
	https://github.com/gentoo-crate-dist/mitmproxy_rs/releases/download/v${PV}/${P/-/_}-crates.tar.xz
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD ISC
	LGPL-3+ MIT Unicode-3.0 WTFPL-2 ZLIB
"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	~net-proxy/mitmproxy-linux-${PV}[${PYTHON_USEDEP}]
"

python_test() {
	cargo_src_test --manifest-path mitmproxy-rs/Cargo.toml
}
