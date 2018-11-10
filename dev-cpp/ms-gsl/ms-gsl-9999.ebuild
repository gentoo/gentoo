# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="Guideline Support Library implementation by Microsoft"
HOMEPAGE="https://github.com/Microsoft/GSL"
SRC_URI=""
EGIT_REPO_URI="https://github.com/Microsoft/GSL.git"

S="${WORKDIR}/GSL-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="test"

# header only library
RDEPEND=""
DEPEND="test? ( ~dev-cpp/catch-1.11.0 )"

PATCHES=(
	"${FILESDIR}/${PN}-1.0.0-use_system_catch-636828.patch"
	"${FILESDIR}/${PN}-1.0.0-disable_Werror-644042.patch"
)

src_configure() {
	local mycmakeargs=(
		-DGSL_TEST=$(usex test)
	)
	use test && mycmakeargs+=( -DFORCE_SYSTEM_CATCH=ON )
	cmake-utils_src_configure
}
