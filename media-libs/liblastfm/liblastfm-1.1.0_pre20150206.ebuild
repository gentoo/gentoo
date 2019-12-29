# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT=44331654256df83bc1d3cbb271a8ce3d4c464686
inherit cmake

DESCRIPTION="Collection of libraries to integrate Last.fm services"
HOMEPAGE="https://github.com/lastfm/liblastfm"
SRC_URI="https://github.com/lastfm/liblastfm/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
SLOT="0/0"
IUSE="fingerprint test"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtxml:5
	fingerprint? (
		dev-qt/qtsql:5
		media-libs/libsamplerate
		sci-libs/fftw:3.0
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? ( dev-qt/qttest:5 )
"

# 1 of 2 (UrlBuilderTest) is failing, last checked version 1.0.9
RESTRICT="test"

S="${WORKDIR}/${PN}-${COMMIT}"

PATCHES=( "${FILESDIR}/${P}-qt-5.11b3.patch" )

src_configure() {
	# demos not working
	local mycmakeargs=(
		-DBUILD_DEMOS=OFF
		-DBUILD_WITH_QT4=OFF
		-DBUILD_FINGERPRINT=$(usex fingerprint)
		-DBUILD_TESTS=$(usex test)
	)

	cmake_src_configure
}
