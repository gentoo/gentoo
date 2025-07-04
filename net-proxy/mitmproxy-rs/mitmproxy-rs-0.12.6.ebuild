# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"

declare -A GIT_CRATES=(
	[boringtun]='https://github.com/cloudflare/boringtun;e3252d9c4f4c8fc628995330f45369effd4660a1;boringtun-%commit%/boringtun'
)

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{12..14} )
RUST_MIN_VER=1.85.0

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

src_prepare() {
	distutils-r1_src_prepare

	# replace upstream crate substitution with our crate substitution, sigh
	local bor_dep=$(grep ^boringtun "${ECARGO_HOME}"/config.toml || die)
	sed -i -e "/boringtun/s;^.*$;${bor_dep};" Cargo.toml || die
}

python_test() {
	cargo_src_test --manifest-path mitmproxy-rs/Cargo.toml
}
