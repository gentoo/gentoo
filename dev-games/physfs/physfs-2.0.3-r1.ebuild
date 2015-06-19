# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/physfs/physfs-2.0.3-r1.ebuild,v 1.7 2015/04/09 13:14:54 jmorgan Exp $

EAPI=5
inherit cmake-multilib

DESCRIPTION="Abstraction layer for filesystem and archive access"
HOMEPAGE="http://icculus.org/physfs/"
SRC_URI="http://icculus.org/physfs/downloads/${P}.tar.bz2"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="doc grp hog mvl qpak static-libs wad +zip"

RDEPEND=""
DEPEND="doc? ( app-doc/doxygen )"

src_prepare() {
	sed -i -e 's:-Werror::' CMakeLists.txt || die
	# make sure these libs aren't used
	rm -rf lzma zlib*
}

src_configure() {
	local mycmakeargs="
		-DPHYSFS_ARCHIVE_7Z=OFF
		-DPHYSFS_BUILD_SHARED=ON
		-DPHYSFS_BUILD_TEST=OFF
		-DPHYSFS_BUILD_WX_TEST=OFF
		-DPHYSFS_INTERNAL_ZLIB=OFF
		$(cmake-utils_use static-libs PHYSFS_BUILD_STATIC)
		$(cmake-utils_use grp PHYSFS_ARCHIVE_GRP)
		$(cmake-utils_use hog PHYSFS_ARCHIVE_HOG)
		$(cmake-utils_use mvl PHYSFS_ARCHIVE_MVL)
		$(cmake-utils_use wad PHYSFS_ARCHIVE_WAD)
		$(cmake-utils_use qpak PHYSFS_ARCHIVE_QPAK)
		$(cmake-utils_use zip PHYSFS_ARCHIVE_ZIP)"

	cmake-multilib_src_configure
}

src_compile() {
	cmake-multilib_src_compile

	if multilib_is_native_abi && use doc ; then
		doxygen || die "doxygen failed"
	fi
}

src_install() {
	local DOCS="CHANGELOG.txt CREDITS.txt TODO.txt"
	local HTML_DOCS=$(use doc && echo docs/html/*)

	cmake-multilib_src_install
}
