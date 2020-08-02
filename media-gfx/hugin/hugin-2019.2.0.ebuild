# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

WX_GTK_VER="3.0"
PYTHON_COMPAT=( python3_{6,7,8} )

inherit python-single-r1 wxwidgets cmake-utils eapi7-ver xdg

MY_PV="${PV/_/-}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="GUI for the creation & processing of panoramic images"
HOMEPAGE="http://hugin.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2+ BSD BSD-2 MIT wxWinLL-3 ZLIB FDL-1.2"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

LANGS=" ca ca-valencia cs da de en-GB es eu fi fr hu it ja nl pl pt-BR ro ru sk sv zh-CN zh-TW"
IUSE="debug lapack python raw sift $(echo ${LANGS//\ /\ l10n_})"

CDEPEND="
	!!dev-util/cocom
	dev-db/sqlite:3
	dev-libs/boost:=
	dev-libs/zthread
	>=media-gfx/enblend-4.0
	media-gfx/exiv2:=
	media-libs/freeglut
	media-libs/glew:=
	>=media-libs/libpano13-2.9.19_beta1:0=
	media-libs/libpng:0=
	media-libs/openexr:=
	media-libs/tiff:0
	>=media-libs/vigra-1.11.0[openexr]
	sci-libs/fftw:3.0=
	sci-libs/flann
	sys-libs/zlib
	virtual/glu
	virtual/jpeg:0
	virtual/opengl
	x11-libs/wxGTK:3.0=[X,opengl]
	lapack? ( virtual/blas virtual/lapack )
	python? ( ${PYTHON_DEPS} )
	sift? ( media-gfx/autopano-sift-C )"
RDEPEND="${CDEPEND}
	media-libs/exiftool
	raw? ( media-gfx/dcraw )"
DEPEND="${CDEPEND}
	dev-cpp/tclap
	sys-devel/gettext
	virtual/pkgconfig
	python? ( >=dev-lang/swig-2.0.4 )"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DOCS=( authors.txt README TODO )

S=${WORKDIR}/${PN}-$(ver_cut 1-2).0

pkg_setup() {
	use python && python-single-r1_pkg_setup
	setup-wxwidgets
}

src_prepare() {
	sed -i \
		-e "/COMMAND.*GZIP/d" \
		-e "s/\.gz//g" \
		"${S}"/doc/CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_HSI=$(usex python)
		-DENABLE_LAPACK=$(usex lapack)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	use python && python_optimize

	local lang
	for lang in ${LANGS} ; do
		case ${lang} in
			ca) dir=ca_ES;;
			ca-valencia) dir=ca_ES@valencia;;
			cs) dir=cs_CZ;;
			*) dir=${lang/-/_};;
		esac
		if ! use l10n_${lang} ; then
			rm -r "${ED%/}"/usr/share/locale/${dir} || die
		fi
	done
}
