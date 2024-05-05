# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit tree-sitter-grammar

DESCRIPTION="Ruby grammar for Tree-sitter"
HOMEPAGE="https://github.com/tree-sitter/tree-sitter-ruby"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

# Highlight tests failing in upstream ci too. The parser works, and
# we do not currently install the highlight queries.
#
# https://bugs.gentoo.org/923987
# https://github.com/tree-sitter/tree-sitter-ruby/issues/253
RESTRICT="test"
