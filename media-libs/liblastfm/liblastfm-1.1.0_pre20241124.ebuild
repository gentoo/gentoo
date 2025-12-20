# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=2e8e40d78a331d8e39fe39113bcb7571a7b1d4d6
inherit cmake

DESCRIPTION="Collection of libraries to integrate Last.fm services"
HOMEPAGE="https://github.com/lastfm/liblastfm https://github.com/drfiemost/liblastfm"
SRC_URI="https://github.com/lastfm/liblastfm/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3"
KEYWORDS="amd64 ~arm64 ~ppc ~ppc64 x86"
SLOT="0"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="dev-qt/qtbase:6[dbus,network,ssl,xml]"
DEPEND="${RDEPEND}"

# Pending: https://github.com/drfiemost/liblastfm/pull/9
PATCHES=( "${FILESDIR}/${P}-strict-flags.patch" )

src_configure() {
	local mycmakeargs=(
		-DBUILD_DEMOS=OFF # demos not working
		-DBUILD_WITH_QT5=OFF
		-DBUILD_FINGERPRINT=OFF # https://github.com/lastfm/liblastfm/issues/43
		-DBUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}

src_test() {
	local CMAKE_SKIP_TESTS=(
		UrlBuilderTest # fails without network access
	)
	cmake_src_test
}
