# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit tree-sitter-grammar

DESCRIPTION="Clojure programming language grammar for Tree-sitter"
HOMEPAGE="https://github.com/sogaiu/tree-sitter-clojure/"
SRC_URI="https://github.com/sogaiu/${PN}/archive/v${PV}.tar.gz
	-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DOCS=( CHANGELOG.md README.md )

src_install() {
	tree-sitter-grammar_src_install
	einstalldocs
}
