# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit tree-sitter-grammar

DESCRIPTION="Markdown grammar for Tree-sitter"
HOMEPAGE="https://github.com/tree-sitter-grammars/tree-sitter-markdown"

SRC_URI="https://github.com/tree-sitter-grammars/${PN}/archive/${TS_PV:-v${PV}}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/${P}/${PN}/src"
