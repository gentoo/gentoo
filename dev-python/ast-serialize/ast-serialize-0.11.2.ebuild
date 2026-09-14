# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYPI_VERIFY_REPO=https://github.com/mypyc/ast_serialize
PYTHON_COMPAT=( python3_{12..15} python3_{14,15}t )

RUST_MIN_VER="1.95.0"
CRATES="
"

inherit cargo distutils-r1 pypi

DESCRIPTION="Python bindings for mypy AST serialization"
HOMEPAGE="
	https://github.com/mypyc/ast_serialize/
	https://pypi.org/project/ast-serialize/
"
SRC_URI+="
	https://github.com/gentoo-crate-dist/ast_serialize/releases/download/v${PV}/ast_serialize-${PV}-crates.tar.xz
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT Unicode-3.0
	Unicode-DFS-2016 ZLIB
"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

EPYTEST_IGNORE=(
	crates
)

QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/ast_serialize/ast_serialize.*"

src_unpack() {
	pypi_src_unpack
	cargo_gen_config
}
