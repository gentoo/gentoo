# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

TS_BINDINGS=( python )

inherit tree-sitter-grammar

DESCRIPTION="HTML grammar for Tree-sitter"
HOMEPAGE="https://github.com/tree-sitter/tree-sitter-html"
SRC_URI="https://github.com/tree-sitter-grammars/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

PATCHES=( "${FILESDIR}"/${P}-make.patch )

python_test() {
	# Silencing QA warning
	:
}
