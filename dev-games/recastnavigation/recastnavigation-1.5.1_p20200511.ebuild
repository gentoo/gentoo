# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Navigation mesh construction toolset for games"
HOMEPAGE="https://github.com/recastnavigation/recastnavigation"
MY_COMMIT="df27e4eb1a4ade9912f8b7d75c25769a3193dbd0"
SRC_URI="https://github.com/recastnavigation/recastnavigation/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/recastnavigation-1.5.1_p20200511-install.patch"
)

src_configure() {
	local mycmakeargs=(
		-DRECASTNAVIGATION_DEMO=OFF
		-DRECASTNAVIGATION_EXAMPLES=OFF
		-DRECASTNAVIGATION_STATIC=OFF
		-DRECASTNAVIGATION_TESTS=$(usex test)
	)

	cmake_src_configure
}
