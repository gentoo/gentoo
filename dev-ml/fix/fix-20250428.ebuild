# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Facilities for memoization and fixed points"
HOMEPAGE="https://gitlab.inria.fr/fpottier/fix"
SRC_URI="https://gitlab.inria.fr/fpottier/fix/-/archive/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt"
RESTRICT="test"  # regenerate not yet packaged
