# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake-multilib

DESCRIPTION="Abstraction layer for filesystem and archive access"
HOMEPAGE="https://icculus.org/physfs/"

if [[ ${PV} == *9999* ]]; then
	EHG_REPO_URI="https://hg.icculus.org/icculus/physfs"
	inherit mercurial
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc64 ~x86 ~x86-fbsd"
	SRC_URI="https://icculus.org/physfs/downloads/${P}.tar.bz2"
fi

LICENSE="ZLIB"
SLOT="0"
IUSE="7zip doc grp hog iso mvl qpak slb static-libs vdf wad +zip"

BDEPEND="doc? ( app-doc/doxygen )"

DOCS=( docs/CHANGELOG.txt docs/CREDITS.txt docs/TODO.txt )

multilib_src_configure() {
	local mycmakeargs=(
		-DPHYSFS_BUILD_SHARED=ON
		-DPHYSFS_BUILD_TEST=OFF
		-DPHYSFS_BUILD_STATIC="$(usex static-libs)"
		-DPHYSFS_ARCHIVE_7Z="$(usex 7zip)"
		-DPHYSFS_ARCHIVE_GRP="$(usex grp)"
		-DPHYSFS_ARCHIVE_HOG="$(usex hog)"
		-DPHYSFS_ARCHIVE_ISO9660="$(usex iso)"
		-DPHYSFS_ARCHIVE_MVL="$(usex mvl)"
		-DPHYSFS_ARCHIVE_SLB="$(usex slb)"
		-DPHYSFS_ARCHIVE_VDF="$(usex vdf)"
		-DPHYSFS_ARCHIVE_WAD="$(usex wad)"
		-DPHYSFS_ARCHIVE_QPAK="$(usex qpak)"
		-DPHYSFS_ARCHIVE_ZIP="$(usex zip)"
	)
	cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile
	multilib_is_native_abi && use doc && cmake-utils_src_compile docs
}

multilib_src_install_all() {
	einstalldocs
	if use doc ; then
		docinto html
		dodoc -r "${CMAKE_BUILD_DIR}"/docs/html/*
	fi
}
