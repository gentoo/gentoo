# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="edge-addition-planarity-suite-Version"
DESCRIPTION="The edge addition planarity suite of graph algorithms"
HOMEPAGE="https://github.com/graph-algorithms/edge-addition-planarity-suite/"

# Use the tarball from sage because the github release doesn't
# contain the generated autotools files (like ./configure).
SRC_URI="http://files.sagemath.org/spkg/upstream/${PN}/${P}.tar.gz"
IUSE="examples static-libs"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

# https://github.com/graph-algorithms/edge-addition-planarity-suite/issues/4
# https://github.com/graph-algorithms/edge-addition-planarity-suite/pull/3
PATCHES=( "${FILESDIR}/${P}-extern.patch" )

S="${WORKDIR}/${MY_PN}_${PV}"

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
	use examples && dodoc -r c/samples
}
