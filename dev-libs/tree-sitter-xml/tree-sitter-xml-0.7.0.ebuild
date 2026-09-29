# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

TS_BINDINGS=( python )

DISTUTILS_OPTIONAL=1
inherit tree-sitter-grammar distutils-r1

DESCRIPTION="HTML grammar for Tree-sitter"
HOMEPAGE="https://github.com/tree-sitter/tree-sitter-html"
SRC_URI="https://github.com/tree-sitter-grammars/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

PATCHES=( "${FILESDIR}"/${P}-make.patch )

src_test() {
	tree-sitter-grammar_src_test

	use python && distutils-r1_src_test
}

python_test() {
	epytest bindings/python/tests
}
