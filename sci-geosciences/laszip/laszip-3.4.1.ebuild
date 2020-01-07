# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Library for free and lossless compression of the LAS LiDAR format"
HOMEPAGE="https://laszip.org/"
SRC_URI="https://github.com/LASzip/LASzip/releases/download/${PV}/${PN}-src-${PV}.tar.gz"

SLOT="0"
LICENSE="LGPL-2.1+"
KEYWORDS="amd64 ~ia64 ppc ppc64 x86"

S="${WORKDIR}/${PN}-src-${PV}"
