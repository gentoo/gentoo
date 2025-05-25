# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic virtualx

# Components/Overlay/CMakeLists.txt
IMGUI_PV="1.91.2"

DESCRIPTION="Object-oriented Graphics Rendering Engine"
HOMEPAGE="https://www.ogre3d.org/"
SRC_URI="
	https://github.com/OGRECave/ogre/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
	https://github.com/ocornut/imgui/archive/v${IMGUI_PV}.tar.gz
		-> imgui-${IMGUI_PV}.tar.gz
"

LICENSE="MIT public-domain"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~x86"

IUSE="assimp bullet cg doc +dotscene egl-only freeimage +gl3plus gles2 glslang opengl qt6 samples test tiny tools sdl vulkan wayland"
REQUIRED_USE="
	|| ( gl3plus gles2 opengl tiny vulkan )
	egl-only? ( || ( gl3plus gles2 opengl ) )
	test? ( samples )
	vulkan? ( glslang )
	wayland? ( egl-only )
"
# vulkan broken, proper handling required for wayland
RESTRICT="
	!test? ( test )
	vulkan? ( test )
	wayland? ( test )
"

# freetype and zlib are automagic
# vulkan-loader is dlopen'd
RDEPEND="
	media-libs/freetype:2
	sys-libs/zlib
	assimp? ( media-libs/assimp:= )
	bullet? ( sci-physics/bullet:= )
	cg? ( media-gfx/nvidia-cg-toolkit )
	dotscene? ( dev-libs/pugixml )
	freeimage? ( media-libs/freeimage )
	gl3plus? ( virtual/opengl )
	glslang? ( dev-util/glslang:= )
	gles2? ( virtual/opengl )
	opengl? ( virtual/opengl )
	qt6? ( dev-qt/qtbase:6[gui] )
	sdl? ( media-libs/libsdl2 )
	tools? ( dev-libs/pugixml )
	vulkan? ( media-libs/vulkan-loader )
	wayland? ( dev-libs/wayland )
	!wayland? (
		x11-libs/libX11
		x11-libs/libXaw
		x11-libs/libXt
		gl3plus? ( x11-libs/libXrandr )
		gles2? ( x11-libs/libXrandr )
		opengl? ( x11-libs/libXrandr )
	)
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )
	vulkan? ( dev-util/vulkan-headers )
"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen[dot] )
"

src_prepare() {
	cmake_src_prepare

	# Users should set this via their CFLAGS (like -march)
	sed -e '/check_cxx_compiler_flag(-msse OGRE_GCC_HAS_SSE)/d' \
		-i CMakeLists.txt || die

	# Force Qt6
	sed -e '/find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Gui QUIET CONFIG)/ { s/Qt5// }' \
		-i CMake/Dependencies.cmake || die

	# Lets not install test binaries
	sed -e '/ogre_install_target(Test_Ogre "" FALSE)/d' \
		-i Tests/CMakeLists.txt || die
}

src_configure() {
	# odr violations
	filter-lto

	local mycmakeargs=(
		# https://gitweb.gentoo.org/repo/gentoo.git/commit/?id=fb809aeadee57ffa24591e60cfb41aecd4823090
		-DOGRE_ENABLE_PRECOMPILED_HEADERS=OFF

		-DOGRE_BUILD_COMPONENT_BITES=ON
		-DOGRE_BUILD_COMPONENT_BULLET=$(usex bullet)
		-DOGRE_BUILD_COMPONENT_CSHARP=OFF
		-DOGRE_BUILD_COMPONENT_JAVA=OFF
		-DOGRE_BUILD_COMPONENT_MESHLODGENERATOR=ON
		-DOGRE_BUILD_COMPONENT_OVERLAY=ON
		-DOGRE_BUILD_COMPONENT_OVERLAY_IMGUI=ON
		-DOGRE_BUILD_COMPONENT_PAGING=ON
		-DOGRE_BUILD_COMPONENT_PROPERTY=ON
		-DOGRE_BUILD_COMPONENT_PYTHON=OFF
		-DOGRE_BUILD_COMPONENT_RTSHADERSYSTEM=ON
		-DOGRE_BUILD_COMPONENT_TERRAIN=ON
		-DOGRE_BUILD_COMPONENT_VOLUME=ON

		-DOGRE_BUILD_PLUGIN_ASSIMP=$(usex assimp)
		-DOGRE_BUILD_PLUGIN_BSP=ON
		-DOGRE_BUILD_PLUGIN_CG=$(usex cg) # "deprecated"
		-DOGRE_BUILD_PLUGIN_DOT_SCENE=$(usex dotscene)
		-DOGRE_BUILD_PLUGIN_EXRCODEC=OFF # "deprecated" and doesn't work
		-DOGRE_BUILD_PLUGIN_FREEIMAGE=$(usex freeimage) # "deprecated"
		-DOGRE_BUILD_PLUGIN_GLSLANG=$(usex glslang)
		-DOGRE_BUILD_PLUGIN_OCTREE=ON
		-DOGRE_BUILD_PLUGIN_PCZ=ON
		-DOGRE_BUILD_PLUGIN_PFX=ON
		-DOGRE_BUILD_PLUGIN_RSIMAGE=OFF # rust
		-DOGRE_BUILD_PLUGIN_STBI=ON # vendored stb headers

		-DOGRE_BUILD_RENDERSYSTEM_GL=$(usex opengl)
		-DOGRE_BUILD_RENDERSYSTEM_GL3PLUS=$(usex gl3plus)
		-DOGRE_BUILD_RENDERSYSTEM_GLES2=$(usex gles2)
		# "BETA". Tests will not pass with this
		-DOGRE_BUILD_RENDERSYSTEM_VULKAN=$(usex vulkan)
		-DOGRE_BUILD_RENDERSYSTEM_TINY=$(usex tiny)

		-DOGRE_BUILD_SAMPLES=$(usex samples)
		-DOGRE_INSTALL_SAMPLES=$(usex samples)
		-DOGRE_BUILD_TOOLS=$(usex tools)
		-DOGRE_INSTALL_TOOLS=$(usex tools)
		-DOGRE_BUILD_XSIEXPORTER=OFF # softimage
		-DOGRE_BUILD_TESTS=$(usex test)

		-DOGRE_BUILD_DEPENDENCIES=OFF
		-DIMGUI_DIR="${WORKDIR}/imgui-${IMGUI_PV}"

		-DOGRE_CFG_INSTALL_PATH="/etc/OGRE"
		-DOGRE_MEDIA_PATH="share/OGRE/Media"

		-DOGRE_DOCS_PATH="share/docs/${PF}"
		-DOGRE_INSTALL_DOCS=$(usex doc)

		$(cmake_use_find_package qt6 QT)
		$(cmake_use_find_package sdl SDL2)
	)

	if use gl3plus || use gles2 || use opengl ; then
		mycmakeargs+=(
			# TODO: wayland support needs more work.
			# tests don't run with tinywl and it doesnt work at runtime
			-DOGRE_USE_WAYLAND=$(usex wayland)
			-DOGRE_GLSUPPORT_USE_EGL=$(usex egl-only)
		)
	fi

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_build OgreDoc
}

src_test() {
	virtx cmake_src_test
}

pkg_postinst() {
	if use samples; then
		elog "If you experience crashes when starting /usr/bin/SampleBrowser,"
		elog "remove the cache directory at:"
		elog "  '~/.cache/OGRE Sample Browser'"
		elog "first, before filing a bug report."
	fi
}
