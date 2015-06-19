# Copyright 2012-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/innoextract/innoextract-1.2.ebuild,v 1.1 2012/06/29 21:26:51 hasufell Exp $

EAPI=4

inherit cmake-utils

DESCRIPTION="A tool to unpack installers created by Inno Setup"
HOMEPAGE="http://innoextract.constexpr.org/"
SRC_URI="mirror://github/dscharrer/InnoExtract/${P}.tar.gz
	mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +lzma"

DEPEND=">=dev-libs/boost-1.37
	lzma? ( app-arch/xz-utils )"
RDEPEND="${DEPEND}"

DOCS=( README.md CHANGELOG )

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_configure() {
	use debug && CMAKE_BUILD_TYPE=Debug

	local mycmakeargs=(
		$(cmake-utils_use lzma USE_LZMA)
	)

	cmake-utils_src_configure
}
