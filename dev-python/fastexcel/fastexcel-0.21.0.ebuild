# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"
RUST_MIN_VER="1.88.0"

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{12..14} )

inherit cargo distutils-r1

DESCRIPTION="A fast excel file reader for Python, written in Rust"
HOMEPAGE="
	https://github.com/ToucanToco/fastexcel/
	https://pypi.org/project/fastexcel/
"
SRC_URI="
	https://github.com/ToucanToco/fastexcel/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	https://github.com/gentoo-crate-dist/fastexcel/releases/download/v${PV}/${P}-crates.tar.xz
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD Boost-1.0
	CC0-1.0 MIT Unicode-3.0 ZLIB
"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	test? (
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/polars[${PYTHON_USEDEP}]
		dev-python/pyarrow[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

QA_PREBUILT="/usr/lib/python.*/site-packages/fastexcel/_fastexcel.*"

python_test() {
	rm -rf python/fastexcel || die
	epytest
}
