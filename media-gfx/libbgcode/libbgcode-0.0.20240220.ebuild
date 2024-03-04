# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

LIBBGCODE_COMMIT=33a1eebfb8e65f333c057c13734f3a838e31d433

DESCRIPTION="Prusa Block & Binary G-code reader / writer / converter"
HOMEPAGE="https://github.com/prusa3d/libbgcode"
SRC_URI="https://github.com/prusa3d/libbgcode/archive/${LIBBGCODE_COMMIT}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-${LIBBGCODE_COMMIT}"
LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

# catch is not needed only for tests: đ926168
DEPEND="
	=dev-cpp/catch-2*:0
	>=dev-libs/boost-1.82
	>=dev-libs/heatshrink-0.4.1
	>=dev-python/pybind11-2.11
	>=sys-libs/zlib-1.0
"
RDEPEND="${DEPEND}"
