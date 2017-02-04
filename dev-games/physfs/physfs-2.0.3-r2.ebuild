# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit cmake-multilib

DESCRIPTION="Abstraction layer for filesystem and archive access"
HOMEPAGE="http://icculus.org/physfs/"
SRC_URI="http://icculus.org/physfs/downloads/${P}.tar.bz2"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE="doc grp hog mvl qpak static-libs wad +zip"

RDEPEND=""
DEPEND="doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}/${P}-zip_seek.diff"
)

src_prepare() {
	default
	sed -i -e 's:-Werror::' CMakeLists.txt || die
	# make sure these libs aren't used
	rm -rf lzma zlib*
}

src_configure() {
	local mycmakeargs=(
		-DPHYSFS_ARCHIVE_7Z=OFF
		-DPHYSFS_BUILD_SHARED=ON
		-DPHYSFS_BUILD_TEST=OFF
		-DPHYSFS_BUILD_WX_TEST=OFF
		-DPHYSFS_INTERNAL_ZLIB=OFF
		-DPHYSFS_BUILD_STATIC="$(usex static-libs)"
		-DPHYSFS_ARCHIVE_GRP="$(usex grp)"
		-DPHYSFS_ARCHIVE_HOG="$(usex hog)"
		-DPHYSFS_ARCHIVE_MVL="$(usex mvl)"
		-DPHYSFS_ARCHIVE_WAD="$(usex wad)"
		-DPHYSFS_ARCHIVE_QPAK="$(usex qpak)"
		-DPHYSFS_ARCHIVE_ZIP="$(usex zip)"
	)

	cmake-multilib_src_configure
}

src_compile() {
	cmake-multilib_src_compile

	if multilib_is_native_abi && use doc ; then
		doxygen || die "doxygen failed"
	fi
}

src_install() {
	local DOCS=( CHANGELOG.txt CREDITS.txt TODO.txt )
	local HTML_DOCS=$(usex doc 'docs/html/*' '')

	cmake-multilib_src_install
}
