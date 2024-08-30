# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Implementation of the codec specified in the JPEG-2000 Part-1 standard"
HOMEPAGE="https://jasper-software.github.io/jasper"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jasper-software/jasper.git"
else
	SRC_URI="https://github.com/jasper-software/${PN}/archive/version-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 ~arm arm64 ~loong x86"
	S="${WORKDIR}/${PN}-version-${PV}"
fi

LICENSE="JasPer2.0"
SLOT="0/7"
IUSE="doc heif jpeg opengl test"
RESTRICT="!test? ( test )"

RDEPEND="
	heif? ( media-libs/libheif:= )
	jpeg? ( media-libs/libjpeg-turbo:= )
	opengl? (
		media-libs/freeglut
		virtual/opengl
		virtual/glu
	)"
DEPEND="${RDEPEND}"
BDEPEND="
	app-shells/bash
	doc? (
		app-text/doxygen
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-plaingeneric
		virtual/latex-base
	)
	test? ( media-libs/openjpeg )"

src_configure() {
	local mycmakeargs=(
		-DBASH_PROGRAM="${BROOT}"/bin/bash

		# documentation
		$(cmake_use_find_package doc Doxygen)
		$(cmake_use_find_package doc LATEX)

		# HEIF
		-DJAS_ENABLE_LIBHEIF=$(usex heif)

		# JPEG
		-DJAS_ENABLE_LIBJPEG=$(usex jpeg)

		# OpenGL
		-DJAS_ENABLE_OPENGL=$(usex opengl)
	)
	cmake_src_configure
}
