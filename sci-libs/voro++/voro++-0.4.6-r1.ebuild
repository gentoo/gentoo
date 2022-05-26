# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="3D Voronoi cell software library"
HOMEPAGE="http://math.lbl.gov/voro++/"
SRC_URI="http://math.lbl.gov/voro++/download/dir/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

PATCHES=( "${FILESDIR}/${P}-cmake.patch" )
