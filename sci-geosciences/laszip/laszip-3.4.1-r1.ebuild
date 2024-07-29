# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="Library for free and lossless compression of the LAS LiDAR format"
HOMEPAGE="https://laszip.org/"
SRC_URI="https://github.com/LASzip/LASzip/releases/download/${PV}/${PN}-src-${PV}.tar.bz2"

SLOT="0"
LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

S="${WORKDIR}/${PN}-src-${PV}"

src_configure() {
	# -Werror=odr
	# https://bugs.gentoo.org/862582
	# Fixed in newer version.
	filter-lto

	cmake_src_configure
}
