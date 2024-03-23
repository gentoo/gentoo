# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

LIBBGCODE_COMMIT=bc390aab4427589a6402b4c7f65cf4d0a8f987ec

DESCRIPTION="Prusa Block & Binary G-code reader / writer / converter"
HOMEPAGE="https://github.com/prusa3d/libbgcode"
SRC_URI="https://github.com/prusa3d/libbgcode/archive/${LIBBGCODE_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"

DEPEND="
	>=dev-libs/boost-1.82
	>=dev-libs/heatshrink-0.4.1
	>=dev-cpp/catch-2.13:0
	<dev-cpp/catch-3:0
	>=dev-python/pybind11-2.11
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${LIBBGCODE_COMMIT}"
