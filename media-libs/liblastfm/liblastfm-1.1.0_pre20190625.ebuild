# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT=f867df52757c569d97d9755c911ac9dec146f365
inherit cmake flag-o-matic

DESCRIPTION="Collection of libraries to integrate Last.fm services"
HOMEPAGE="https://github.com/lastfm/liblastfm"
SRC_URI="https://github.com/lastfm/liblastfm/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
SLOT="0/0"
IUSE="fingerprint test"

# 1 of 2 (UrlBuilderTest) is failing, last checked version 1.0.9
RESTRICT="test"

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
DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:5 )
"

PATCHES=( "${FILESDIR}/${P}-missing-dep.patch" )

src_prepare() {
	append-cxxflags -std=c++14 # bug 787128
	cmake_src_prepare
}

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
