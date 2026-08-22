# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Zyan Core Library for C"
HOMEPAGE="https://github.com/zyantific/zycore-c"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/zyantific/zycore-c.git"
else
	SRC_URI="https://github.com/zyantific/zycore-c/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"
IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="
	doc? ( app-text/doxygen )
	test? ( dev-cpp/gtest )
"

PATCHES=(
	"${FILESDIR}/${PN}-1.5.2-build-documentation-only-when-requested.patch"
)

src_configure() {
	local mycmakeargs=(
		-DZYCORE_BUILD_SHARED_LIB=yes
		-DZYCORE_BUILD_TESTS=$(usex test)
		-DZYCORE_BUILD_DOCS=$(usex doc)
	)

	cmake_src_configure
}
