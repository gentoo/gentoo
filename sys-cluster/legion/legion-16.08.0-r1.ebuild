# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="A data-centric parallel programming system"
HOMEPAGE="http://legion.stanford.edu/"
SRC_URI="https://github.com/StanfordLegion/${PN}/archive/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gasnet +hwloc"

DEPEND="
	gasnet? ( >=sys-cluster/gasnet-1.26.4-r1 )
	hwloc? ( sys-apps/hwloc )
	"

S="${WORKDIR}/${PN}-${P}"

#https://github.com/StanfordLegion/legion/pull/166
#https://github.com/StanfordLegion/legion/pull/167
PATCHES=( "${FILESDIR}/${P}-hwloc.patch" "${FILESDIR}/${P}-multilib.patch" )

src_configure() {
	mycmakeargs=(
		-DLegion_USE_HWLOC=$(usex hwloc)
		-DLegion_USE_GASNet=$(usex gasnet)
		-DBUILD_SHARED_LIBS=ON
		-DLIB=$(get_libdir)
	)
	cmake-utils_src_configure
}
