# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit tree-sitter-grammar

# Upstream has not created a release in a while, and there have been
# some changes that fix weirdness with Emacs tree-sitter-mode.
GIT_COMMIT="0b6d0eb9abdf7cea31961cd903eeed5bbd0aae74"

DESCRIPTION="C++ grammar for Tree-sitter"
HOMEPAGE="https://github.com/tree-sitter/tree-sitter-cpp"
SRC_URI="https://github.com/tree-sitter/${PN}/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${GIT_COMMIT}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64"

# requires test data from tree-sitter-c
RESTRICT="test"
