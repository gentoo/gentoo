# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="Release"
EGIT_COMMIT="7d97bb29c4db1d79702402f8331d9be371a87f83"
MY_PN="${PN/intel-/}"
MY_P="${MY_PN}-${PV}"

inherit cmake

DESCRIPTION="A user mode driver helper library that provides access to GPU performance counters"
HOMEPAGE="https://github.com/intel/metrics-library"
SRC_URI="https://github.com/intel/${MY_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${EGIT_COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

DEPEND="x11-libs/libdrm"
RDEPEND="${DEPEND}"
