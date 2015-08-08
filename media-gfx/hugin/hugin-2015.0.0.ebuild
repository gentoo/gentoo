# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WX_GTK_VER="2.8"
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit base python-single-r1 wxwidgets versionator cmake-utils

DESCRIPTION="GUI for the creation & processing of panoramic images"
HOMEPAGE="http://hugin.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2 SIFT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

LANGS=" ca@valencia ca_ES cs_CZ da de en_GB es eu fi fr hu it ja nl pl pt_BR ro ru sk sv zh_CN zh_TW"
IUSE="debug lapack python sift $(echo ${LANGS//\ /\ linguas_})"

CDEPEND="
	!!dev-util/cocom
	dev-db/sqlite:3
	>=dev-libs/boost-1.49.0-r1:=
	dev-libs/zthread
	>=media-gfx/enblend-4.0
	media-gfx/exiv2:=
	media-libs/freeglut
	media-libs/glew:=
	>=media-libs/libpano13-2.9.19_beta1:0=
	media-libs/libpng:0=
	media-libs/openexr:=
	media-libs/tiff:0
	>=media-libs/vigra-1.9.0[openexr]
	sci-libs/fftw:=
	sys-libs/zlib
	virtual/glu
	virtual/jpeg:0
	virtual/opengl
	x11-libs/wxGTK:2.8=[X,opengl,-odbc]
	lapack? ( virtual/blas virtual/lapack )
	sift? ( media-gfx/autopano-sift-C )"
RDEPEND="${CDEPEND}
	media-libs/exiftool"
DEPEND="${CDEPEND}
	dev-cpp/tclap
	sys-devel/gettext
	virtual/pkgconfig
	python? ( ${PYTHON_DEPS} >=dev-lang/swig-2.0.4 )"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

S=${WORKDIR}/${PN}-$(get_version_component_range 1-3)

pkg_setup() {
	DOCS="authors.txt README TODO"
	mycmakeargs=(
		$(cmake-utils_use_enable lapack LAPACK)
		$(cmake-utils_use_build python HSI)
	)
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	sed \
		-e 's:-O3::g' \
		-i src/celeste/CMakeLists.txt || die
	rm CMakeModules/{FindLAPACK,FindPkgConfig}.cmake || die

	cmake-utils_src_prepare
}

src_install() {
	cmake-utils_src_install
	use python && python_optimize

	for lang in ${LANGS} ; do
		case ${lang} in
			ca@valencia) dir=ca_ES@valencia;;
			*) dir=${lang};;
		esac
		use linguas_${lang} || rm -r "${D}"/usr/share/locale/${dir}
	done
}
