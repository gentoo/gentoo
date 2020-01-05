# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{5,6,7} )

inherit cmake flag-o-matic python-single-r1

DESCRIPTION="A free open-source montecarlo raytracing engine"
HOMEPAGE="http://www.yafaray.org"
SRC_URI="https://github.com/YafaRay/Core/archive/v${PV}.tar.gz -> ${PN}-core-${PV}.tar.gz
	https://github.com/YafaRay/Blender-Exporter/archive/v${PV}.tar.gz -> ${PN}-blender-exporter-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+blender +fastmath +fasttrig jpeg opencv openexr png +python tiff truetype"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-libs/boost:=
	dev-libs/libxml2:2
	sys-libs/zlib
	blender? ( media-gfx/blender )
	jpeg? ( virtual/jpeg:0 )
	opencv? ( >=media-libs/opencv-3.1.0:=[openexr?] )
	openexr? ( >=media-libs/openexr-2.2.0:= )
	png? ( media-libs/libpng:0= )
	python? ( ${PYTHON_DEPS} )
	tiff? ( media-libs/tiff:0 )
	truetype? ( media-libs/freetype:2 )
"
DEPEND="${RDEPEND}"
BDEPEND="dev-lang/swig"

S="${WORKDIR}/Core-${PV}"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	append-flags "-pthread"
	cmake_src_prepare

	sed -i -e "s/@YAFARAY_BLENDER_EXPORTER_VERSION@/v${PV}/" "${WORKDIR}/Blender-Exporter-${PV}/__init__.py" || die

	eapply "${FILESDIR}/${P}-strip-debug-mode.patch"
	eapply "${FILESDIR}/${P}-respect-cflags.patch"
	pushd "${WORKDIR}/Blender-Exporter-${PV}" || die
	eapply "${FILESDIR}/${P}-blender-exporter-paths.patch"
	popd || dir
	eapply_user
}

src_configure() {
	local mycmakeargs=(
		-DYAF_LIB_DIR=$(get_libdir)
		-DWITH_YAF_PY_BINDINGS=$(usex python)
		-DYAF_PY_VERSION=${EPYTHON#python}
		-DWITH_YAF_RUBY_BINDINGS=OFF
		-DBLENDER_ADDON=OFF # addon is a separate package called blender-exporter
		-DCMAKE_SKIP_RPATH=ON # NULL DT_RUNPATH security problem
		-DFAST_MATH=$(usex fastmath)
		-DFAST_TRIG=$(usex fasttrig)
		-DWITH_JPEG="$(usex jpeg)"
		-DWITH_OpenCV="$(usex opencv)"
		-DWITH_OpenEXR="$(usex openexr)"
		-DWITH_PNG="$(usex png)"
		-DWITH_QT=OFF # qt4 only at the moment
		-DWITH_TIFF="$(usex tiff)"
		-DWITH_Freetype="$(usex truetype)"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	python_domodule "${BUILD_DIR}/src/bindings/yafaray_v3_interface.py"
	python_domodule "${BUILD_DIR}/src/bindings/_yafaray_v3_interface.so"
	rm -v "${ED}"/usr/$(get_libdir)/{yafaray_v3_interface.py,_yafaray_v3_interface.so} || die
	rm -rv "${ED}"/usr/share/doc/${PN} || die

	if use blender; then
		pushd "${WORKDIR}/Blender-Exporter-${PV}" || die
		rm README LICENSES INSTALL CHANGELOG .gitignore || die
		# grab blender version number for plugin directory
		local blender_plugin_dir=$(best_version media-gfx/blender)
		blender_plugin_dir=${blender_plugin_dir##*/} # remove category
		blender_plugin_dir=${blender_plugin_dir#*-}  # remove package name
		blender_plugin_dir=${blender_plugin_dir%%-*} # remove revision number if exists
		insinto /usr/share/blender/${blender_plugin_dir}/scripts/addons/yafaray_v3
		doins -r .
		popd || die
	fi
}

pkg_postinst() {
	einfo "To confirm your installation is working as expected, run"
	einfo "yafaray-xml with /usr/share/yafaray/tests/test01/test01.xml"
	einfo "as an input file, then compare the result to"
	einfo "'/usr/share/yafaray/tests/test01/test01 - expected render result.png'"
	if use blender; then
		elog
		elog "To use within Blender, navigate to File -> User Preferences -> Add-ons (tab)"
		elog "and enable 'Render: YafaRay v3 Exporter'. This will make YafaRay available"
		elog "in the render engines drop-down."
	fi
}
