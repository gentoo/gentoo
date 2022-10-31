# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )

# doesn't build with ninja when qt5 and python USE flags are both enabled
CMAKE_MAKEFILE_GENERATOR="emake"

inherit cmake flag-o-matic python-single-r1

DESCRIPTION="A free open-source montecarlo raytracing engine"
# Regular homepage is currently down. Upstream is working on this.
HOMEPAGE="https://www.yafaray.org https://github.com/YafaRay/libYafaRay"
SRC_URI="https://github.com/YafaRay/libYafaRay/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/libYafaRay-${PV}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+fastmath +fasttrig jpeg opencv png python qt5 tiff truetype"
RESTRICT="test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# Note: according to upstream, the blender plugin doesn't work with >=blender-2.8 (yet).
RDEPEND="
	dev-libs/libxml2:2
	sys-libs/zlib
	jpeg? ( media-libs/libjpeg-turbo:= )
	opencv? ( media-libs/opencv:= )
	png? ( media-libs/libpng:= )
	python? ( ${PYTHON_DEPS} )
	qt5? ( dev-qt/qtwidgets:5 )
	tiff? ( media-libs/tiff )
	truetype? ( media-libs/freetype:2 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	python? (
		${PYTHON_DEPS}
		dev-lang/swig
	)
"

PATCHES=(
	"${FILESDIR}"/${P}-0001-respect-distribution-CFLAGS.patch
	"${FILESDIR}"/${P}-add-missing-limits-header.patch
)

DOCS=( AUTHORS.md CHANGELOG.md CODING.md INSTALL.md README.md )

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	append-flags -pthread
	append-ldflags -pthread

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		# enabling BLENDER_ADDON doesn't build anything, but set's some wierd
		# installation paths, so keep it off and install the files manually.
		-DBLENDER_ADDON=OFF
		-DFAST_MATH=$(usex fastmath)
		-DFAST_TRIG=$(usex fasttrig)
		-DWITH_Freetype=$(usex truetype)
		-DWITH_JPEG=$(usex jpeg)
		-DWITH_OpenCV=$(usex opencv)
		-DWITH_OpenEXR=OFF # bug #877865
		-DWITH_PNG=$(usex png)
		-DWITH_QT=$(usex qt5)
		-DWITH_TIFF=$(usex tiff)
		-DWITH_XML_LOADER=ON
		-DWITH_XMLImport=ON
		-DWITH_YAF_PY_BINDINGS=$(usex python)
		-DWITH_YAF_RUBY_BINDINGS=OFF
		-DYAF_DOC_DIR=share/doc/${PF}
		-DYAF_LIB_DIR=$(get_libdir)
	)

	if use python; then
		mycmakeargs+=( -DYAF_PY_VERSION=${EPYTHON#python} )
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use python; then
		python_domodule "${BUILD_DIR}/src/bindings/yafaray_v3_interface.py"
		mv "${ED}"/usr/$(get_libdir)/_yafaray_v3_interface.so "${ED}"/$(python_get_sitedir)/ || die
		rm -v "${ED}"/usr/$(get_libdir)/yafaray_v3_interface.py || die

		if use qt5; then
			python_domodule "${BUILD_DIR}/src/bindings/yafqt.py"
			mv "${ED}"/usr/$(get_libdir)/_yafqt.so "${ED}"/$(python_get_sitedir)/ || die
			rm -v "${ED}"/usr/$(get_libdir)/yafqt.py || die
		fi
	fi
}

pkg_postinst() {
	einfo "To confirm your installation is working as expected, run"
	einfo "yafaray-xml with /usr/share/yafaray/tests/test01/test01.xml"
	einfo "as an input file, then compare the result to"
	einfo "'/usr/share/yafaray/tests/test01/test01 - expected render result.png'"
}
