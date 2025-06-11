# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Bandwidth test for ROCm"
HOMEPAGE="https://github.com/ROCm/rocm_bandwidth_test"
SRC_URI="https://github.com/ROCm/${PN}/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-rocm-${PV}"
LICENSE="NCSA-AMD"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

DEPEND="dev-libs/rocr-runtime:="
RDEPEND="${DEPEND}"
