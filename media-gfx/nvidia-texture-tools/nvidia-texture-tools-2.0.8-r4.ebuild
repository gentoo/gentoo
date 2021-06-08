# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils edos2unix

DESCRIPTION="A set of cuda-enabled texture tools and compressors"
HOMEPAGE="http://developer.nvidia.com/object/texture_tools.html"
SRC_URI="https://${PN}.googlecode.com/files/${P}-1.tar.gz
	https://dev.gentoo.org/~soap/distfiles/${P}-patchset-1-r1.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="cg glew glut openexr"

RDEPEND="
	media-libs/ilmbase:=
	media-libs/libpng:0=
	media-libs/tiff:0
	sys-libs/zlib
	virtual/jpeg:0
	virtual/opengl
	x11-libs/libX11
	cg? ( media-gfx/nvidia-cg-toolkit )
	glew? ( media-libs/glew:0= )
	glut? ( media-libs/freeglut )
	openexr? ( media-libs/openexr:= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${P}-cg.patch" # fix bug #414509
	"${FILESDIR}/${P}-gcc-4.7.patch" # fix bug #423965
	"${FILESDIR}/${P}-openexr.patch" # fix bug #462494
	"${FILESDIR}/${P}-clang.patch" # fix clang build
	"${FILESDIR}/${P}-cpp14.patch" # fix bug #594938
	"${FILESDIR}/${P}-drop-qt4.patch" # fix bug #560248
	"${WORKDIR}/patches"
)

S="${WORKDIR}/${PN}"

src_prepare() {
	edos2unix cmake/*
	cmake-utils_src_prepare
}

src_configure() {
	# cuda support requires old gcc 4.5 that is hardmasked in current
	# profiles
	local mycmakeargs=(
		-DCUDA=no
		-DLIBDIR=$(get_libdir)
		-DNVTT_SHARED=TRUE
		-DCG=$(usex cg)
		-DGLEW=$(usex glew)
		-DGLUT=$(usex glut)
		-DOPENEXR=$(usex openexr)
	)
	cmake-utils_src_configure
}
