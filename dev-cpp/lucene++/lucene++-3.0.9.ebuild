# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="LucenePlusPlus-rel_${PV}"
inherit cmake

DESCRIPTION="C++ port of Lucene library, a high-performance, full-featured text search engine"
HOMEPAGE="https://github.com/luceneplusplus/LucenePlusPlus"
SRC_URI="https://github.com/luceneplusplus/LucenePlusPlus/archive/rel_${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="|| ( LGPL-3 Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~loong ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug"
RESTRICT="test"

DEPEND="dev-libs/boost:=[zlib]"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-3.0.7-boost-1.85.patch"
	"${FILESDIR}/${PN}-3.0.9-boost-1.87.patch"
	"${FILESDIR}/${PN}-3.0.9-pkgconfig.patch"
)

src_configure() {
	local mycmakeargs=(
		-DENABLE_DEMO=OFF
		-DENABLE_TEST=OFF
	)

	cmake_src_configure
}
