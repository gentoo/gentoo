# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Bindings to ncurses"
HOMEPAGE="https://github.com/mbacarella/curses"
SRC_URI="https://github.com/mbacarella/${PN}/releases/download/${PV}/${P}.tbz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="dev-ml/dune-configurator"

PATCHES=( "${FILESDIR}"/${P}-CC.patch )
