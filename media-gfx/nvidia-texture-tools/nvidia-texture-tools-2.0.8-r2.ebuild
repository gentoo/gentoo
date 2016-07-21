# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit cmake-utils eutils multilib toolchain-funcs

DESCRIPTION="A set of cuda-enabled texture tools and compressors"
HOMEPAGE="http://developer.nvidia.com/object/texture_tools.html"
SRC_URI="https://${PN}.googlecode.com/files/${P}-1.tar.gz
	https://dev.gentoo.org/~ssuominen/${P}-patchset-1.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="cg cuda glew glut openexr"

RDEPEND="media-libs/libpng:0
	media-libs/ilmbase
	media-libs/tiff:0
	sys-libs/zlib
	virtual/jpeg
	virtual/opengl
	x11-libs/libX11
	cg? ( media-gfx/nvidia-cg-toolkit )
	cuda? ( dev-util/nvidia-cuda-toolkit )
	glew? ( media-libs/glew )
	glut? ( media-libs/freeglut )
	openexr? ( media-libs/openexr )
	"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${PN}

pkg_setup() {
	if use cuda; then
		if [[ $(( $(gcc-major-version) * 10 + $(gcc-minor-version) )) -gt 44 ]] ; then
			eerror "gcc 4.5 and up are not supported for useflag cuda!"
			die "gcc 4.5 and up are not supported for useflag cuda!"
		fi
	fi
}

src_prepare() {
	edos2unix cmake/*
	EPATCH_SUFFIX=patch epatch "${WORKDIR}"/patches
	# fix bug #414509
	epatch "${FILESDIR}"/${P}-cg.patch
	# fix bug #423965
	epatch "${FILESDIR}"/${P}-gcc-4.7.patch
	# fix bug #462494
	epatch "${FILESDIR}"/${P}-openexr.patch
	# fix clang build
	epatch "${FILESDIR}"/${P}-clang.patch
}

src_configure() {
	local mycmakeargs=(
		-DLIBDIR=$(get_libdir)
		-DNVTT_SHARED=TRUE
		$(cmake-utils_use cg CG)
		$(cmake-utils_use cuda CUDA)
		$(cmake-utils_use glew GLEW)
		$(cmake-utils_use glut GLUT)
		$(cmake-utils_use openexr OPENEXR)
		)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	dodoc ChangeLog
}
