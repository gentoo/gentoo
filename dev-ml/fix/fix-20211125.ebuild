# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Facilities for memoization and fixed points"
HOMEPAGE="https://gitlab.inria.fr/fpottier/fix"
SRC_URI="https://gitlab.inria.fr/fpottier/fix/-/archive/${PV}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt"
RESTRICT="test"  # regenerate & qcheck not yet packaged
