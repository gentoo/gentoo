# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit tree-sitter-grammar

DESCRIPTION="Markdown grammar for Tree-sitter"
HOMEPAGE="https://github.com/tree-sitter-grammars/tree-sitter-markdown"
SRC_URI="https://github.com/tree-sitter-grammars/tree-sitter-markdown/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}/${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
