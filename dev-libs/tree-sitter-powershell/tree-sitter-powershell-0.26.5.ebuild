# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit tree-sitter-grammar

DESCRIPTION="PowerShell programming language grammar for Tree-sitter"
HOMEPAGE="https://github.com/airbus-cert/tree-sitter-powershell/"
SRC_URI="https://github.com/airbus-cert/${PN}/archive/v${PV}.tar.gz
	-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DOCS=( README.md )

src_install() {
	tree-sitter-grammar_src_install
	einstalldocs
}
