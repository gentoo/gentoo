# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"
RUST_MIN_VER="1.88.0"

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{12..15} )

inherit cargo distutils-r1 pypi

DESCRIPTION="Provides OpenPGP facilities using Sequoia-PGP library"
HOMEPAGE="
	https://github.com/wiktor-k/pysequoia
	https://pypi.org/project/pysequoia/
"

if [[ ${PKGBUMPING} != ${PVR} ]]; then
	SRC_URI+="
		https://github.com/gentoo-crate-dist/${PN}/releases/download/v${PV}/${P}-crates.tar.xz
		${CARGO_CRATE_URIS}
	"
fi

LICENSE="Apache-2.0"
# Dependent crate licenses
LICENSE+="
	Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 LGPL-2+ MIT
	Unicode-3.0 ZLIB
"
SLOT="0"
KEYWORDS="~amd64"

QA_FLAGS_IGNORED="usr/lib/python.*/site-packages/pysequoia/.*.so"

EPYTEST_PLUGINS=()
EPYTEST_XDIST=1
distutils_enable_tests pytest

src_test() {
	cargo_src_test
	distutils-r1_src_test
}
