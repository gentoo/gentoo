# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Library for free and lossless compression of the LAS LiDAR format"
HOMEPAGE="https://laszip.org/"
SRC_URI="https://github.com/LASzip/LASzip/releases/download/${PV}/${PN}-src-${PV}.tar.gz"
S="${WORKDIR}/${PN}-src-${PV}"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
