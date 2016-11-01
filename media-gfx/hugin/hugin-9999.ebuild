# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WX_GTK_VER="3.0"
PYTHON_COMPAT=( python{2_7,3_4} )

inherit mercurial python-single-r1 wxwidgets versionator cmake-utils

DESCRIPTION="GUI for the creation & processing of panoramic images"
HOMEPAGE="http://hugin.sf.net"
SRC_URI=""
EHG_REPO_URI="http://hg.code.sf.net/p/hugin/hugin"
EHG_PROJECT="${PN}-${PN}"

LICENSE="GPL-2 SIFT"
SLOT="0"
KEYWORDS=""

LANGS=" ca ca-valencia cs da de en-GB es eu fi fr hu it ja nl pl pt-BR ro ru sk sv zh-CN zh-TW"
IUSE="debug lapack python sift $(echo ${LANGS//\ /\ l10n_})"

CDEPEND="
	!!dev-util/cocom
	dev-db/sqlite:3
	>=dev-libs/boost-1.49.0-r1:0=
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
	x11-libs/wxGTK:3.0=[X,opengl]
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
		-DBUILD_HSI=$(usex python ON OFF)
		-DENABLE_LAPACK=$(usex lapack ON OFF)
	)
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	rm CMakeModules/{FindLAPACK,FindPkgConfig}.cmake || die

	cmake-utils_src_prepare
}

src_install() {
	cmake-utils_src_install
	use python && python_optimize

	for lang in ${LANGS} ; do
		case ${lang} in
			ca) dir=ca_ES;;
			ca-valencia) dir=ca_ES@valencia;;
			cs) dir=cs_CZ;;
			*) dir=${lang/-/_};;
		esac
		use l10n_${lang} || rm -r "${D}"/usr/share/locale/${dir}
	done
}
