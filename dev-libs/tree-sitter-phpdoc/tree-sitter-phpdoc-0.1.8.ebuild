# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit tree-sitter-grammar

DESCRIPTION="PHPDoc grammar for Tree-sitter"
HOMEPAGE="https://github.com/claytonrcarter/tree-sitter-phpdoc"
SRC_URI="https://github.com/claytonrcarter/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~riscv"

src_prepare() {
	sed -e "s/VERSION := 0.0.1/VERSION := ${PV}/" \
		-i Makefile \
		|| die "failed to fix VERSION in Makefile"
	tree-sitter-grammar_src_prepare
}
