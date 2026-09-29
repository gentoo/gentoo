# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

CommitId=9a2c49b00852d012dc97850a3c0b3248f15bd043
DESCRIPTION="Grep source code and see useful code context about matching lines"
HOMEPAGE="
	https://pypi.org/project/grep_ast/
"
SRC_URI="https://github.com/Aider-AI/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.gh.tar.gz"
S="${WORKDIR}"/${PN}-${CommitId}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# In portage, to add here
#"clojure",
#"csharp",
#"erlang",
#"gleam",
#"go",
#"haskell",
#"java",
#"jsdoc",
#"json",
#"julia",
#"kconfig",
#"lua",
#"ocaml",
#"php",
#"powershell",
#"racket",
#"ruby",
#"rust",
#"scala",
#"typescript",
#"vim",

RDEPEND="
	dev-python/tree-sitter[${PYTHON_USEDEP}]
	dev-libs/tree-sitter-bash[python,${PYTHON_USEDEP}]
	dev-libs/tree-sitter-c[python,${PYTHON_USEDEP}]
	dev-libs/tree-sitter-cmake[python,${PYTHON_USEDEP}]
	dev-libs/tree-sitter-cpp[python,${PYTHON_USEDEP}]
	dev-libs/tree-sitter-css[python(-),${PYTHON_USEDEP}]
	dev-libs/tree-sitter-html[python,${PYTHON_USEDEP}]
	dev-libs/tree-sitter-javascript[python,${PYTHON_USEDEP}]
	dev-libs/tree-sitter-markdown[python(-),${PYTHON_USEDEP}]
	dev-libs/tree-sitter-python[python,${PYTHON_USEDEP}]
	dev-libs/tree-sitter-xml[python,${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

PATCHES=( "${FILESDIR}"/${P}-treesitter.patch )

src_prepare() {
	cp "${FILESDIR}"/tsl.py grep_ast/tsl.py || die
	distutils-r1_src_prepare
}
