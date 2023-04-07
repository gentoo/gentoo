# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Implementation of the codec specified in the JPEG-2000 Part-1 standard"
HOMEPAGE="https://jasper-software.github.io/jasper"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jasper-software/jasper.git"
else
	SRC_URI="https://github.com/jasper-software/${PN}/archive/version-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	S="${WORKDIR}/${PN}-version-${PV}"
fi

LICENSE="JasPer2.0"
SLOT="0"
IUSE="doc heif jpeg opengl"

RDEPEND="
	heif? ( media-libs/libheif )
	jpeg? ( media-libs/libjpeg-turbo:= )
	opengl? (
		virtual/opengl
		media-libs/freeglut
		virtual/glu
		x11-libs/libXi
		x11-libs/libXmu
	)"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? ( app-doc/doxygen )
"

multilib_src_configure() {
	local mycmakeargs=(
		-DBASH_PROGRAM="${BROOT}"/bin/bash

		# HEIF
		-DJAS_ENABLE_LIBHEIF=$(usex heif)

		# JPEG
		-DJAS_ENABLE_LIBJPEG=$(usex jpeg)
		-DCMAKE_DISABLE_FIND_PACKAGE_JPEG=$(usex !jpeg)

		# OpenGL
		-DJAS_ENABLE_OPENGL=$(usex opengl)
		-DCMAKE_DISABLE_FIND_PACKAGE_OpenGL=$(usex !opengl)
	)
	cmake_src_configure
}
