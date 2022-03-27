# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# The swig fork is required for compatibility with both provided and
# 3rd-party Python scripts.  Required patch was sent to upstream in
# 2014: https://github.com/swig/swig/pull/251
MY_SWIG_VER=7
MY_SWIG=swig-${PN}-${MY_SWIG_VER}

AUTOTOOLS_AUTO_DEPEND="no"
DOCS_BUILDER="sphinx"
DOCS_DIR="docs"
PYTHON_COMPAT=( python3_{9,10} )
inherit autotools cmake optfeature python-single-r1 docs xdg

DESCRIPTION="A stand-alone graphics debugging tool"
HOMEPAGE="https://renderdoc.org https://github.com/baldurk/renderdoc"
SRC_URI="
	https://github.com/baldurk/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	qt5? ( https://github.com/baldurk/swig/archive/${PN}-modified-${MY_SWIG_VER}.tar.gz -> ${MY_SWIG}.tar.gz )
"

# renderdoc: MIT
#   + cmdline: BSD (not compatible with upstream lib)
#   + farm fresh icons: CC-BY-3.0
#   + half: MIT (not compatible with system dev-libs/half)
#   + include-bin ZLIB (upstream doesn't exist anymore, maintained in tree)
#   + md5: public-domain
#   + plthook: BSD-2
#   + pugixml: MIT
#   + radeon gpu analyzer: MIT
#   + source code pro: OFL-1.1
#   + stb: public-domain
#   + tinyfiledialogs: ZLIB
#   + docs? ( sphinx.paramlinks: MIT )
# swig: GPL-3+ BSD BSD-2
LICENSE="BSD BSD-2 CC-BY-3.0 GPL-3+ MIT OFL-1.1 public-domain ZLIB"
SLOT="0"
KEYWORDS="~amd64"
IUSE="pyside2 qt5"
REQUIRED_USE="doc? ( qt5 ) pyside2? ( qt5 ) qt5? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	app-arch/lz4:=
	app-arch/zstd:=
	dev-libs/miniz:=
	dev-util/glslang
	x11-libs/libX11
	x11-libs/libxcb:=
	x11-libs/xcb-util-keysyms
	virtual/opengl
	pyside2? (
		$(python_gen_cond_dep '
			dev-python/pyside2[${PYTHON_USEDEP}]
		')
	)
	qt5? (
		${PYTHON_DEPS}
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5[ssl]
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
		dev-qt/qtx11extras:5
	)
"
DEPEND="${RDEPEND}"
# qtcore provides qmake, which is required to build the qrenderdoc gui.
BDEPEND="
	x11-base/xorg-proto
	virtual/pkgconfig
	qt5? (
		${AUTOTOOLS_DEPEND}
		${PYTHON_DEPS}
		dev-libs/libpcre
		dev-qt/qtcore:5
		sys-devel/bison
	)
"

PATCHES=(
	# The analytics seem very reasonable, and even without this patch
	# they are NOT sent before the user accepts.  But default the
	# selection to off, just in case.
	"${FILESDIR}"/${PN}-1.18-analytics-off.patch

	# Only search for PySide2 if pyside2 USE flag is set.
	# Bug #833627
	"${FILESDIR}"/${PN}-1.18-conditional-pyside.patch

	# Pass CXXFLAGS and LDFLAGS through to qmake when qrenderdoc is
	# built.
	"${FILESDIR}"/${PN}-1.18-system-flags.patch

	# Needed to prevent sandbox violations during build.
	"${FILESDIR}"/${PN}-1.18-env-home.patch

	"${FILESDIR}"/${PN}-1.18-system-glslang.patch
	"${FILESDIR}"/${PN}-1.18-system-compress.patch

	# Check physical device API version and supported extensions.  Fixes
	# segfault on some GPU/driver combinations.  Will be in release 1.19
	"${FILESDIR}"/${PN}-1.18-check-api-ver.patch
)

DOCS=( util/LINUX_DIST_README )

pkg_setup() {
	use qt5 && python-single-r1_pkg_setup
}

src_unpack() {
	# Do not unpack the swig sources here.  CMake will do that if
	# required.
	unpack ${P}.tar.gz
}

src_prepare() {
	cmake_src_prepare

	# Remove the calls to install the documentation files.  Instead,
	# install them with einstalldocs.
	sed -i '/share\/doc\/renderdoc/d' \
		"${S}"/CMakeLists.txt "${S}"/qrenderdoc/CMakeLists.txt \
		|| die 'sed remove doc install failed'

	# Assumes that the build directory is "${S}"/build, which it is not.
	sed -i "s|../build/lib|${BUILD_DIR}/lib|" \
		"${S}"/docs/conf.py \
		|| die 'sed patch doc sys.path failed'

	# Bug #836235
	sed -i '/#include <stdarg/i #include <time.h>' \
		"${S}"/renderdoc/os/os_specific.h \
		|| die 'sed include time.h failed'
}

src_configure() {
	local mycmakeargs=(
		# Build system does not know that this is a tagged release, as
		# we just have the tarball and not the git repository.
		-DBUILD_VERSION_STABLE=ON

		-DENABLE_EGL=ON
		-DENABLE_GL=ON
		-DENABLE_GLES=ON
		-DENABLE_PYRENDERDOC=$(usex qt5)
		-DENABLE_QRENDERDOC=$(usex qt5)
		-DENABLE_VULKAN=ON

		# Upstream says that this option is unsupported and should not
		# be used yet.
		-DENABLE_WAYLAND=OFF

		-DENABLE_XCB=ON
		-DENABLE_XLIB=ON

		# Path to glslang*.cmake.
		-DGLSLANG_TARGET_DIR="${ESYSROOT}"/usr/$(get_libdir)/cmake

		# renderdoc_capture.json is installed here
		-DVULKAN_LAYER_FOLDER="${EPREFIX}"/etc/vulkan/implicit_layer.d
	)

	use qt5 && mycmakeargs+=(
		-DPython3_EXECUTABLE="${PYTHON}"
		-DRENDERDOC_SWIG_PACKAGE="${DISTDIR}"/${MY_SWIG}.tar.gz
		-DQRENDERDOC_ENABLE_PYSIDE2=$(usex pyside2)
	)

	use pyside2 && mycmakeargs+=( -DPYTHON_CONFIG_SUFFIX=-${EPYTHON} )

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	docs_compile
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature "android remote contexts" dev-util/android-tools
	optfeature "vulkan contexts" media-libs/vulkan-loader
}
