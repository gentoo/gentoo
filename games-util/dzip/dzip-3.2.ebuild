# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="compressor/uncompressor for demo recordings from id's Quake"
HOMEPAGE="https://speeddemosarchive.com/dzip/"
SRC_URI="https://github.com/kugelrund/dzip/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://speeddemosarchive.com/quake/qdq/demos/qd100qlite2.dz )"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="virtual/zlib:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-cmake.patch"
)

src_test() {
	# All we can really do here is unpack a demo and confirm we get an expected result
	"${BUILD_DIR}"/dzip -v "${DISTDIR}/qd100qlite2.dz" || die "Failed to unpack test demo"
	"${BUILD_DIR}"/dzip -l "${DISTDIR}/qd100qlite2.dz"
}
