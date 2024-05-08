# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit tree-sitter-grammar

DESCRIPTION="CSS grammar for Tree-sitter"
HOMEPAGE="https://github.com/tree-sitter/tree-sitter-css"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

PATCHES=(
	# https://bugs.gentoo.org/928010
	# Test name beginning with :: is incompatible with tree-sitter >0.22
	"${FILESDIR}"/${PN}-0.20.0-test-selector.patch
)
