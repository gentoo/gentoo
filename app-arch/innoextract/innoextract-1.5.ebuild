# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils cmake-utils

DESCRIPTION="A tool to unpack installers created by Inno Setup"
HOMEPAGE="http://constexpr.org/innoextract/"
SRC_URI="http://constexpr.org/innoextract/files/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +iconv +lzma"

RDEPEND="
	dev-libs/boost:=
	iconv? ( virtual/libiconv )
	lzma? ( app-arch/xz-utils )"
DEPEND="${RDEPEND}"

DOCS=( README.md CHANGELOG )

PATCHES=(
	"${FILESDIR}"/${PN}-1.4-cmake-3.5.patch
)

src_prepare() {
	epatch "${PATCHES[@]}"
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_use lzma LZMA)
		$(cmake-utils_use debug DEBUG)
		-DSET_OPTIMIZATION_FLAGS=OFF
		-DSTRICT_USE=ON
		-DWITH_CONV=$(usex iconv iconv builtin)
	)

	cmake-utils_src_configure
}
