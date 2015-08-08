# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit versionator

DESCRIPTION="Example data file for VTK"
HOMEPAGE="http://www.vtk.org"
SRC_URI="http://www.vtk.org/files/release/$(get_version_component_range 1-2)/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RESTRICT="binchecks strip"

RDEPEND="!<sci-libs/vtk-6"

S="${WORKDIR}"/VTKDATA${PV}

src_install() {
	insinto /usr/share/vtk/data
	doins -r *
}
