# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="A data-centric parallel programming system"
HOMEPAGE="https://legion.stanford.edu/"
if [[ $PV = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://StanfordLegion/${PN}.git https://github.com/StanfordLegion/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/StanfordLegion/${PN}/archive/${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${P}"
fi

LICENSE="BSD"
SLOT="0"
IUSE="gasnet +hwloc test"
RESTRICT="!test? ( test )"

DEPEND="
	gasnet? ( >=sys-cluster/gasnet-1.26.4-r1 )
	hwloc? ( <sys-apps/hwloc-2 )
	"

src_configure() {
	mycmakeargs=(
		-DLegion_USE_HWLOC=$(usex hwloc)
		-DLegion_USE_GASNet=$(usex gasnet)
		-DLegion_ENABLE_TESTING=$(usex test)
		-DBUILD_SHARED_LIBS=ON
		-DLegion_BUILD_EXAMPLES=ON
		-DLegion_BUILD_TESTS=ON
		-DLegion_BUILD_TUTORIAL=ON
	)
	cmake-utils_src_configure
}
