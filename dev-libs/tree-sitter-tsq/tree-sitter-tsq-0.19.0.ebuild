# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Most grammar packages uses "vX.Y" scheme, but this one don't use "v"
# on tag names.
# NB: keep an eye when bumping to the new versions. It's possble that
# they can start using "v"'s, so this kludge will not be needed anymore
TS_PV="${PV}"

inherit tree-sitter-grammar

DESCRIPTION="Tree-sitter query language grammar for Tree-sitter"
HOMEPAGE="https://github.com/tree-sitter/tree-sitter-tsq"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
