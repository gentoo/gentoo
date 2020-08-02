# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="Guideline Support Library implementation by Microsoft"
HOMEPAGE="https://github.com/Microsoft/GSL"
SRC_URI=""
EGIT_REPO_URI="https://github.com/Microsoft/GSL.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="test"
RESTRICT="!test? ( test )"

# header only library
RDEPEND=""
DEPEND="test? ( >=dev-cpp/gtest-1.9.0_pre20190607 )"

PATCHES=(
	"${FILESDIR}/${PN}-1.0.0-disable_Werror-644042.patch"
	"${FILESDIR}/${PN}-3.0.0-use_system_gtest.patch"
)

src_configure() {
	local mycmakeargs=(
		-DGSL_TEST=$(usex test)
	)
	cmake_src_configure
}
