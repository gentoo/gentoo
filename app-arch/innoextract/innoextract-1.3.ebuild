# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/innoextract/innoextract-1.3.ebuild,v 1.3 2012/08/03 13:23:52 ago Exp $

EAPI=4

inherit cmake-utils

DESCRIPTION="A tool to unpack installers created by Inno Setup"
HOMEPAGE="http://innoextract.constexpr.org/"
SRC_URI="mirror://github/dscharrer/InnoExtract/${P}.tar.gz
	mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug doc +lzma"

RDEPEND=">=dev-libs/boost-1.37
	lzma? ( app-arch/xz-utils )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

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

src_compile() {
	cmake-utils_src_compile
	use doc && cmake-utils_src_compile doc
}

src_install() {
	cmake-utils_src_install
	use doc && dohtml -r "${CMAKE_BUILD_DIR}"/doc/html/*
}
