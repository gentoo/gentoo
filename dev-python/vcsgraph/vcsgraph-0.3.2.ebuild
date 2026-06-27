# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/breezy-team/vcsgraph
PYTHON_COMPAT=( python3_{12..14} )

RUST_MIN_VER="1.83"
CRATES=""

inherit cargo distutils-r1 pypi

DESCRIPTION="Graph algorithms for version control systems"
HOMEPAGE="
	https://pypi.org/project/vcsgraph/
	https://github.com/breezy-team/vcsgraph/
"
SRC_URI+="
	https://github.com/gentoo-crate-dist/${PN}/releases/download/v${PV}/${P}-crates.tar.xz
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

BDEPEND="
	dev-python/setuptools-rust[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/vcsgraph/_graph_rs.*.so"

src_unpack() {
	pypi_src_unpack
	cargo_gen_config
}

python_test() {
	cd "${BUILD_DIR}/install$(python_get_sitedir)" || die
	eunittest
}
