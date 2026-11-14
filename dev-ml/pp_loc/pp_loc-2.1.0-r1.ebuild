# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Quote and highlight input fragments at a given source location"
HOMEPAGE="https://github.com/Armael/pp_loc"
SRC_URI="https://github.com/Armael/${PN}/releases/download/v${PV}/${P}.tbz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt"
