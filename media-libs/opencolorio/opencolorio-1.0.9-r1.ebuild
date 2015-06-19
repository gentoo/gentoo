# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/opencolorio/opencolorio-1.0.9-r1.ebuild,v 1.5 2015/04/28 08:11:00 zlogene Exp $

EAPI=5

# Compatibility with Python 3 is declared by upstream, but it is broken in fact, check on bump
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-single-r1 vcs-snapshot

DESCRIPTION="A color management framework for visual effects and animation"
HOMEPAGE="http://opencolorio.org/"
SRC_URI="https://github.com/imageworks/OpenColorIO/archive/v${PV}.tar.gz \
		-> ${P}.tar.gz
	http://dev.gentoo.org/~pinkbyte/distfiles/patches/${P}-yaml-0.5-compat.patch.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc opengl pdf python cpu_flags_x86_sse2 test"

RDEPEND="opengl? (
		media-libs/lcms:2
		>=media-libs/openimageio-1.1.0
		media-libs/glew
		media-libs/freeglut
		virtual/opengl
		)
	python? ( ${PYTHON_DEPS} )
	>=dev-cpp/yaml-cpp-0.5
	dev-libs/tinyxml
	"
DEPEND="${RDEPEND}
	doc? (
		pdf? ( dev-python/sphinx[latex,${PYTHON_USEDEP}] )
		!pdf? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	)
	"

# Documentation building requires Python bindings building
REQUIRED_USE="doc? ( python )"

# Restricting tests, bugs #439790 and #447908
RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${PN}-1.0.8-documentation-gen.patch"
	"${FILESDIR}/${P}-remove-external-doc-utilities.patch"
	"${WORKDIR}/${P}-yaml-0.5-compat.patch"
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	cmake-utils_src_prepare

	use python && python_fix_shebang .
}

src_configure() {
	# Missing features:
	# - Truelight and Nuke are not in portage for now, so their support are disabled
	# - Java bindings was not tested, so disabled
	# Notes:
	# - OpenImageIO is required for building ociodisplay and ocioconvert (USE opengl)
	# - OpenGL, GLUT and GLEW is required for building ociodisplay (USE opengl)
	local mycmakeargs=(
		-DOCIO_BUILD_JNIGLUE=OFF
		-DOCIO_BUILD_NUKE=OFF
		-DOCIO_BUILD_SHARED=ON
		-DOCIO_BUILD_STATIC=OFF
		-DOCIO_STATIC_JNIGLUE=OFF
		-DOCIO_BUILD_TRUELIGHT=OFF
		-DUSE_EXTERNAL_LCMS=ON
		-DUSE_EXTERNAL_TINYXML=ON
		-DUSE_EXTERNAL_YAML=ON
		$(cmake-utils_use doc OCIO_BUILD_DOCS)
		$(cmake-utils_use opengl OCIO_BUILD_APPS)
		$(cmake-utils_use pdf OCIO_BUILD_PDF_DOCS)
		$(cmake-utils_use python OCIO_BUILD_PYGLUE)
		$(cmake-utils_use cpu_flags_x86_sse2 OCIO_USE_SSE)
		$(cmake-utils_use test OCIO_BUILD_TESTS)
	)
	cmake-utils_src_configure
}
