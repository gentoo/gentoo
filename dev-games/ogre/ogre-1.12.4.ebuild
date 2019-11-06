# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_REMOVE_MODULES_LIST="FindFreetype FindDoxygen FindZLIB"
inherit cmake

IMGUI_PN="imgui"
IMGUI_PV="1.74"
IMGUI_P="${IMGUI_PN}-${IMGUI_PV}"

DESCRIPTION="Object-oriented Graphics Rendering Engine"
HOMEPAGE="https://www.ogre3d.org/"
SRC_URI="https://github.com/OGRECave/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/ocornut/${IMGUI_PN}/archive/v${IMGUI_PV}.tar.gz -> ${IMGUI_P}.tar.gz"

LICENSE="MIT public-domain"
SLOT="0/1.12"
KEYWORDS="~amd64 ~arm ~x86"

IUSE="+cache cg debug doc double-precision egl examples experimental +freeimage
	gles2 json openexr +opengl pch profile resman-pedantic tools"

REQUIRED_USE="
	|| ( gles2 opengl )
"

RESTRICT="test" #139905

RDEPEND="
	dev-games/ois
	dev-libs/pugixml
	dev-libs/zziplib
	media-libs/freetype:2
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXrandr
	x11-libs/libXt
	cg? ( media-gfx/nvidia-cg-toolkit )
	egl? ( media-libs/mesa[egl] )
	freeimage? ( media-libs/freeimage )
	gles2? ( media-libs/mesa[gles2] )
	json? ( dev-libs/rapidjson )
	openexr? ( media-libs/openexr:= )
	opengl? (
		virtual/glu
		virtual/opengl
	)
	tools? ( dev-libs/tinyxml[stl] )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-base/xorg-proto
	doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}"/${P}-media_path.patch
	"${FILESDIR}"/${P}-resource_path.patch
	"${FILESDIR}"/${P}-fix_sample_source_install.patch
	"${FILESDIR}"/${PN}-1.10.12-use_system_tinyxml.patch
)

src_unpack() {
	unpack ${P}.tar.gz || die "Unpacking ${P}.zip failed"

	# Ogre 1.12.3 includes imgui, but as a submodule, it is not included
	# in the release.
	cd "${S}"/Components/Overlay/src || die "Unpack incomplete"
	unpack ${IMGUI_P}.tar.gz || die "Unpacking ${IMGUI_P}.zip failed"

	# Without this 'rm', mv puts imgui-1.73 *into* imgui/ instead of renaming.
	rm -rf "${IMGUI_PN}" || die "Removing ${IMGUI_PN} failed"
	mv "${IMGUI_P}" "${IMGUI_PN}" || die "Moving ${IMGUI_P} to ${IMGUI_PN} failed"
}

src_prepare() {
	local broken_png=(
		Icon@2x-72.png
		Default-Portrait~ipad.png
		Default-Portrait@2x~ipad.png
		Default-Landscape@2x~ipad.png
	)

	sed -i \
		-e "s:share/doc/OGRE:share/doc/${PF}:" \
		Docs/CMakeLists.txt || die
	# In this series, the CMAKE_BUILD_TARGET is hard-wired to the
	# installation. And only Debug, MinSizeRel and RelWithDebInfo
	# are supported.
	if use debug; then
		sed -i \
			-e 's/Debug/Gentoo/g' \
			CMake/InstallResources.cmake \
			|| die
		sed -i \
			-e 's/Debug/Gentoo/g' \
			CMake/Utils/OgreConfigTargets.cmake \
			|| die
	else
		sed -i \
			-e 's/MinSizeRel/Gentoo/g' \
			CMake/InstallResources.cmake \
			|| die
		sed -i \
			-e 's/MinSizeRel/Gentoo/g' \
			CMake/Utils/OgreConfigTargets.cmake \
			|| die
	fi

	# Fix broken png files
	einfo "Fixing broken png files."
	pushd "${S}"/Samples/Common/misc 1>/dev/null 2>&1
	for png in "${broken_png[@]}"; do
		pngfix -q --out=out.png ${png}
		mv -f out.png "${png}" || die
	done
	popd 1>/dev/null 2>&1
	einfo "done ..."

	# Fix some path issues
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_INSTALL_RPATH=yes
		-DOGRE_BUILD_COMPONENT_BITES=yes
		-DOGRE_BUILD_COMPONENT_CSHARP=no
		-DOGRE_BUILD_COMPONENT_HLMS=$(usex experimental)
		-DOGRE_BUILD_COMPONENT_JAVA=no
		-DOGRE_BUILD_COMPONENT_OVERLAY=yes
		-DOGRE_BUILD_COMPONENT_OVERLAY_IMGUI=yes
		-DOGRE_BUILD_COMPONENT_PAGING=yes
		-DOGRE_BUILD_COMPONENT_PROPERTY=yes
		-DOGRE_BUILD_COMPONENT_PYTHON=no
		-DOGRE_BUILD_COMPONENT_RTSHADERSYSTEM=yes
		-DOGRE_BUILD_COMPONENT_TERRAIN=yes
		-DOGRE_BUILD_COMPONENT_VOLUME=yes
		-DOGRE_BUILD_DEPENDENCIES=no
		-DOGRE_BUILD_PLUGIN_CG=$(usex cg)
		-DOGRE_BUILD_PLUGIN_FREEIMAGE=$(usex freeimage)
		-DOGRE_BUILD_PLUGIN_EXRCODEC=$(usex openexr)
		-DOGRE_BUILD_RENDERSYSTEM_GL=$(usex opengl)
		-DOGRE_BUILD_RENDERSYSTEM_GL3PLUS=$(usex opengl)
		-DOGRE_BUILD_RENDERSYSTEM_GLES2=$(usex gles2)
		-DOGRE_BUILD_SAMPLES=$(usex examples)
		-DOGRE_BUILD_TESTS=no
		-DOGRE_BUILD_TOOLS=$(usex tools)
		-DOGRE_CONFIG_DOUBLE=$(usex double-precision)
		-DOGRE_CONFIG_ENABLE_GL_STATE_CACHE_SUPPORT=$(usex cache)
		-DOGRE_CONFIG_ENABLE_GLES2_CG_SUPPORT=$(usex gles2 $(usex cg) no)
		-DOGRE_CONFIG_ENABLE_GLES3_SUPPORT=$(usex gles2)
		-DOGRE_CONFIG_THREADS=3
		-DOGRE_CONFIG_THREAD_PROVIDER=std
		-DOGRE_ENABLE_PRECOMPILED_HEADERS=$(usex pch)
		-DOGRE_GLSUPPORT_USE_EGL=$(usex egl)
		-DOGRE_INSTALL_DOCS=$(usex doc)
		-DOGRE_INSTALL_SAMPLES=$(usex examples)
		-DOGRE_INSTALL_SAMPLES_SOURCE=$(usex examples)
		-DOGRE_PROFILING=$(usex profile)
		-DOGRE_RESOURCEMANAGER_STRICT=$(usex resman-pedantic 1 2)
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc ; then
		eninja -C "${BUILD_DIR}" OgreDoc
	fi
}

src_install() {
	cmake_src_install

	CONFIGDIR=/etc/OGRE
	SHAREDIR=/usr/share/OGRE

	# plugins and resources are the main configuration
	insinto "${CONFIGDIR}"
	doins "${BUILD_DIR}"/bin/plugins.cfg
	doins "${BUILD_DIR}"/bin/resources.cfg
	dosym "${CONFIGDIR}"/plugins.cfg "${SHAREDIR}"/plugins.cfg
	dosym "${CONFIGDIR}"/resources.cfg "${SHAREDIR}"/resources.cfg

	# These are only for the sample browser
	if use examples ; then
		insinto "${SHAREDIR}"
		doins "${BUILD_DIR}"/bin/quakemap.cfg
		doins "${BUILD_DIR}"/bin/samples.cfg
	fi
}

pkg_postinst() {
	elog "If you experience crashes when starting /usr/bin/SampleBrowser,"
	elog "remove the cache directory at:"
	elog "  '~/.cache/OGRE Sample Browser'"
	elog "first, before filling a bug report."
}
