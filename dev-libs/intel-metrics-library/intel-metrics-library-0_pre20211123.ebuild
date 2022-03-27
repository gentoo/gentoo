# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="Release"
EGIT_COMMIT="3fd6eb0544fadcec2ac762aedee7c2d5d6479feb"
MY_PN="${PN/intel-/}"
MY_P="${MY_PN}-${PV}"

inherit cmake

DESCRIPTION="A user mode driver helper library that provides access to GPU performance counters"
HOMEPAGE="https://github.com/intel/metrics-library"
SRC_URI="https://github.com/intel/${MY_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${EGIT_COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="x11-libs/libdrm"
RDEPEND="${RDEPEND}"
