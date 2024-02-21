# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit tree-sitter-grammar

DESCRIPTION="VimDoc grammar for Tree-sitter"
HOMEPAGE="https://github.com/neovim/tree-sitter-vimdoc"

SRC_URI="https://github.com/neovim/${PN}/archive/${TS_PV:-v${PV}}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
