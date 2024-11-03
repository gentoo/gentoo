# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_P=StormLib-${PV}
DESCRIPTION="Library to read and write MPQ archives (Diablo, StarCraft)"
HOMEPAGE="
	http://www.zezula.net/en/mpq/stormlib.html
	https://github.com/ladislav-zezula/StormLib/
"
SRC_URI="
	https://github.com/ladislav-zezula/StormLib/archive/v${PV}.tar.gz
		-> ${MY_P}.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-arch/bzip2:=
	dev-libs/libtomcrypt:=[libtommath]
	sys-libs/zlib:=
"
DEPEND=${RDEPEND}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		# interactive test app
		-DSTORM_BUILD_TESTS=OFF
		-DWITH_LIBTOMCRYPT=ON
	)

	cmake_src_configure
}
