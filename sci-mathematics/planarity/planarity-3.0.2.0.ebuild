# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The edge addition planarity suite of graph algorithms"
HOMEPAGE="https://github.com/graph-algorithms/edge-addition-planarity-suite/"

SRC_URI="https://github.com/graph-algorithms/edge-addition-planarity-suite/releases/download/Version_${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
