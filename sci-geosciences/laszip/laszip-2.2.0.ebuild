# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
inherit autotools-utils flag-o-matic

DESCRIPTION="Library for free and lossless compression of the LAS LiDAR format"
HOMEPAGE="http://www.laszip.org/"
SRC_URI="https://github.com/LASzip/LASzip/releases/download/v${PV}/${PN}-src-${PV}.tar.gz"

SLOT="0"
LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~ppc64 ~x86"

S="${WORKDIR}/${PN}-src-${PV}"

PATCHES=(
	"${FILESDIR}"/${P}_fix-build-system.patch
)

src_configure() {
	append-flags -fno-strict-aliasing
	autotools-utils_src_configure
}
