# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake
DESCRIPTION="Common files shared by hipBLAS and hipBLASLt"
HOMEPAGE="https://github.com/ROCm/hipBLAS-common"
SRC_URI="https://github.com/ROCm/hipBLAS-common/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/hipBLAS-common-rocm-${PV}"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

BDEPEND="dev-build/rocm-cmake"
