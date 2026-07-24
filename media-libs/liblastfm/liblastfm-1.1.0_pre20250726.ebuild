# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=0a0737bd89b5d5e04cd8bc40793b60501d26b1bb
PATCHSET="${PN}-1.1.0-patchset"
inherit cmake

DESCRIPTION="Collection of libraries to integrate Last.fm services"
HOMEPAGE="https://github.com/lastfm/liblastfm https://github.com/drfiemost/liblastfm"
SRC_URI="https://github.com/lastfm/liblastfm/archive/${COMMIT}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~asturm/distfiles/${PATCHSET}.tar.xz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc ~ppc64 x86"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="dev-qt/qtbase:6[dbus,network,ssl,xml]"
DEPEND="${RDEPEND}"

PATCHES=( "${WORKDIR}/${PATCHSET}" )

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
