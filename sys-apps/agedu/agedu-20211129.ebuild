# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

# agedu-20151213.59b0ed3.ebuild is not a legitimate name
# so we'll drop versionator and just set MY_P manually.
MY_P="${PN}"-$(ver_cut 1).8cd63c5

DESCRIPTION="A utility for tracking down wasted disk space"
HOMEPAGE="https://www.chiark.greenend.org.uk/~sgtatham/agedu/"
SRC_URI="https://www.chiark.greenend.org.uk/~sgtatham/agedu/${MY_P}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

BDEPEND="doc? ( app-text/halibut )"

# Notes:
# - IPv4 / IPv6 are still optional but enabled by default; they don't
# use the normal option() but it's (from CMakeLists.txt):
#  set(AGEDU_IPV6 ON
#    CACHE BOOL "Build agedu with IPv6 support if possible")
#  set(AGEDU_IPV4 ON
#    CACHE BOOL "Build agedu with IPv4 support if possible")

PATCHES=(
	"${FILESDIR}"/${PN}-20211129-fix-automagic-halibut-docs.patch
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCS=$(usex doc)
	)

	cmake_src_configure
}
