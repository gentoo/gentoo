# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils vcs-snapshot

DESCRIPTION="Guideline Support Library implementation by Microsoft"
HOMEPAGE="https://github.com/Microsoft/GSL"
SRC_URI="https://github.com/Microsoft/${PN}/tarball/d10ebc6555b627c9d1196076a78467e7be505987 -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# header only library
RDEPEND=""
DEPEND="test? ( >=dev-cpp/catch-1.11.0 )"

PATCHES=(
	"${FILESDIR}/${P}-use_system_catch-636828.patch"
)

src_configure() {
	local mycmakeargs=( -DGSL_TEST=$(usex test) )
	cmake-utils_src_configure
}
