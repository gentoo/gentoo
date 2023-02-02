# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Bindings to ncurses"
HOMEPAGE="https://github.com/mbacarella/curses"
SRC_URI="https://github.com/mbacarella/${PN}/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="dev-ml/dune-configurator"
