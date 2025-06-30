# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{11..14} )
inherit cargo distutils-r1

DESCRIPTION="Python wrapper for Brave's adblocking library, which is written in Rust"
HOMEPAGE="https://github.com/ArniDagur/python-adblock"
SRC_URI="
	https://github.com/ArniDagur/python-adblock/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz
	https://dev.gentoo.org/~ionen/distfiles/${P}-vendor.tar.xz
"
S=${WORKDIR}/python-${P}

LICENSE="|| ( MIT Apache-2.0 )"
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT MPL-2.0
	Unicode-DFS-2016
" # crates
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

QA_FLAGS_IGNORED=".*/adblock.*.so"

DOCS=( CHANGELOG.md README.md )

PATCHES=(
	"${FILESDIR}"/${P}-maturin-0.14.13.patch
)

python_test() {
	local EPYTEST_DESELECT=(
		# unimportant (for us) test that uses the dir that we delete below
		# so pytest does not try to load it while lacking extensions
		tests/test_typestubs.py::test_functions_and_methods_exist_in_rust
		# FileNotFound exception test that triggers a new assertion in
		# python:3.13[debug], not an issue for normal usage (bug #931898)
		tests/test_engine.py::test_serde_file
	)
	local EPYTEST_IGNORE=(
		# not very meaningful here (e.g. validates changelog),
		# and needs the deprecated dev-python/toml
		tests/test_metadata.py
	)

	rm -rf adblock || die
	epytest
}
