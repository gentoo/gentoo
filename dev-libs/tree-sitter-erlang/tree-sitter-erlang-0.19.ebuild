# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit tree-sitter-grammar

DESCRIPTION="Erlang programming language grammar for Tree-sitter"
HOMEPAGE="https://github.com/whatsapp/tree-sitter-erlang/"
SRC_URI="https://github.com/whatsapp/${PN}/archive/${PV}.tar.gz
	-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DOCS=( CHANGELOG.md README.md )

src_prepare() {
	rm -r ./pyproject.toml ./test/highlight || die
	tree-sitter-grammar_src_prepare
}

src_install() {
	tree-sitter-grammar_src_install
	einstalldocs
}
