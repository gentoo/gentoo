# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"

declare -A GIT_CRATES=(
	[boringtun]='https://github.com/cloudflare/boringtun;e3252d9c4f4c8fc628995330f45369effd4660a1;boringtun-%commit%/boringtun'
	[smoltcp]='https://github.com/smoltcp-rs/smoltcp;ef67e7b46cabf49783053cbf68d8671ed97ff8d4;smoltcp-%commit%'
)

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{10..13} )

inherit cargo distutils-r1 pypi

DESCRIPTION="mitmproxy's Rust bits"
HOMEPAGE="
	https://github.com/mitmproxy/mitmproxy_rs/
	https://pypi.org/project/mitmproxy-rs/
"
SRC_URI+="
	${CARGO_CRATE_URIS}
"
if [[ ${PKGBUMPING} != ${PVR} ]]; then
	SRC_URI+="
		https://dev.gentoo.org/~mgorny/dist/${P}-crates.tar.xz
	"
fi

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD ISC
	LGPL-3+ MIT Unicode-DFS-2016 WTFPL-2
"
SLOT="0"
KEYWORDS="amd64 ~arm64"

src_prepare() {
	distutils-r1_src_prepare

	# replace upstream crate substitution with our crate substitution, sigh
	sed -i -e '/git =/d' Cargo.toml || die
	sed -i -e '/\[patch\./d' -e '/boringtun/i[patch.crates-io]' \
		"${CARGO_HOME}/config.toml" || die
}

python_test() {
	cargo_src_test --manifest-path mitmproxy-rs/Cargo.toml
}
