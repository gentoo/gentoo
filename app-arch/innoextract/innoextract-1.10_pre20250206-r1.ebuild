# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

COMMIT="6e9e34ed0876014fdb46e684103ef8c3605e382e"
DESCRIPTION="A tool to unpack installers created by Inno Setup"
HOMEPAGE="https://constexpr.org/innoextract/"
SRC_URI="https://github.com/dscharrer/innoextract/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~m68k ppc64 ~x86"
IUSE="debug +iconv +lzma test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/boost:=[bzip2,zlib]
	iconv? ( virtual/libiconv )
	lzma? ( app-arch/xz-utils )
"
DEPEND="
	${RDEPEND}
"

PATCHES=(
	"${FILESDIR}/${PN}-1.9-fix-linkage.patch"
	"${FILESDIR}/${PN}-1.10_pre20250206-boost-1.89.patch"
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
		-DDEBUG=$(usex debug)
		-DSET_OPTIMIZATION_FLAGS=OFF
		-DSTRICT_USE=ON
		-DUSE_LZMA=$(usex lzma)
		-DWITH_CONV=$(usex iconv iconv builtin)
	)
	cmake_src_configure
}
