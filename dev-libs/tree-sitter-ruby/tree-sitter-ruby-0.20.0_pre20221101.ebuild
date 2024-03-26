# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# https://github.com/tree-sitter/tree-sitter-ruby/issues/232
MY_COMMIT=c91960320d0f337bdd48308a8ad5500bd2616979

inherit tree-sitter-grammar

DESCRIPTION="Ruby grammar for Tree-sitter"
HOMEPAGE="https://github.com/tree-sitter/tree-sitter-ruby"
SRC_URI="https://github.com/tree-sitter/${PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${MY_COMMIT}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
