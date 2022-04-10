# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Bandwidth test for ROCm"
HOMEPAGE="https://github.com/RadeonOpenCompute/rocm_bandwidth_test"
SRC_URI="https://github.com/RadeonOpenCompute/${PN}/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="NCSA-AMD"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

DEPEND="dev-libs/rocr-runtime:${SLOT}"
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=( "${FILESDIR}/4.3.0-use-proper-delete-operator.patch" )

S="${WORKDIR}/${PN}-rocm-${PV}"
