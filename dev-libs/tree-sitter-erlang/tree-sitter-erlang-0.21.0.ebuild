# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit tree-sitter-grammar

DESCRIPTION="Erlang programming language grammar for Tree-sitter"
HOMEPAGE="https://github.com/whatsapp/tree-sitter-erlang/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/whatsapp/${PN}"
else
	SRC_URI="https://github.com/whatsapp/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"

DOCS=( CHANGELOG.md README.md )

src_prepare() {
	rm -r ./pyproject.toml ./test/highlight || die
	tree-sitter-grammar_src_prepare
}

src_install() {
	tree-sitter-grammar_src_install
	einstalldocs
}
