# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

MYP=${PN}4-${PV}

DESCRIPTION="C++ library for netCDF"
HOMEPAGE="http://www.unidata.ucar.edu/software/netcdf/"
SRC_URI="https://github.com/Unidata/netcdf-cxx4/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="UCAR-Unidata"
SLOT="0/1"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="examples static-libs"

RDEPEND=">=sci-libs/netcdf-4.2:=[hdf5]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MYP}"

PATCHES=(
	"${FILESDIR}/${PN}-4.2-config.patch"
)

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
	prune_libtool_files
}
