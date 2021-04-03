# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Simple C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
HOMEPAGE="https://stachenov.github.io/quazip/"
SRC_URI="https://github.com/stachenov/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/1"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-qt/qtcore:5
	sys-libs/zlib[minizip]
"
DEPEND="${COMMON_DEPEND}
	test? (
		dev-qt/qtnetwork:5
		dev-qt/qttest:5
	)
"
RDEPEND="${COMMON_DEPEND}
	!=dev-libs/quazip-1.1-r0:1
"

PATCHES=( "${FILESDIR}/${P}-cmake.patch" )

src_configure() {
	local mycmakeargs=(
		-DQUAZIP_QT_MAJOR_VERSION=5
		-DBUILD_TESTING=$(usex test)
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	use test && cmake_build qztest
}
