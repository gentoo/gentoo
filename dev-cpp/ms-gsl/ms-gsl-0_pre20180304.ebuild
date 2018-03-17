# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils vcs-snapshot

DESCRIPTION="Guideline Support Library implementation by Microsoft"
HOMEPAGE="https://github.com/Microsoft/GSL"
SRC_URI="https://github.com/Microsoft/gsl/tarball/6a33b97a84f9c0a60ede78b5db98647e9a48d6c9 -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# header only library
RDEPEND=""
DEPEND="test? ( >=dev-cpp/catch-1.11.0 )"

PATCHES=(
	"${FILESDIR}/ms-gsl-0_pre20180108-use_system_catch-636828.patch"
	"${FILESDIR}/ms-gsl-0_pre20180304-disable_Werror-644042.patch"
)

src_configure() {
	local mycmakeargs=(
		-DGSL_TEST=$(usex test)
		-DFORCE_SYSTEM_CATCH=ON
	)
	cmake-utils_src_configure
}
