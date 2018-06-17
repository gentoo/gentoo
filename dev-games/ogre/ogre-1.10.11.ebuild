# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Object-oriented Graphics Rendering Engine"
HOMEPAGE="https://www.ogre3d.org/"
SRC_URI="https://github.com/OGRECave/${PN}/archive/v${PV}.zip -> ${P}.zip"

LICENSE="MIT public-domain"
SLOT="0/1.10.0"
KEYWORDS="~amd64 ~arm ~x86"

IUSE="cg doc double-precision examples +freeimage gl3plus gles2 gles3 ois +opengl profile tools"

REQUIRED_USE="examples? ( ois )
	gles3? ( gles2 )
	gl3plus? ( opengl )"

RESTRICT="test" #139905

RDEPEND="
	dev-libs/boost
	dev-libs/zziplib
	media-libs/freetype:2
	virtual/glu
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXrandr
	x11-libs/libXt
	cg? ( media-gfx/nvidia-cg-toolkit )
	freeimage? ( media-libs/freeimage )
	gl3plus? ( >=media-libs/mesa-9.2.5 )
	gles2? ( >=media-libs/mesa-9.0.0[gles2] )
	gles3? ( >=media-libs/mesa-10.0.0[gles2] )
	ois? ( dev-games/ois )
	tools? ( dev-libs/tinyxml[stl] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-base/xorg-proto
	doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}/${P}-samples.patch"
	"${FILESDIR}/${P}-resource_path.patch"
	"${FILESDIR}/${P}-media_path.patch"
	"${FILESDIR}/${P}-fix_double_precision-88f0d5b.patch"
)

src_prepare() {
	sed -i \
		-e "s:share/OGRE/docs:share/doc/${PF}:" \
		Docs/CMakeLists.txt || die
	# Stupid build system hardcodes release names
	sed -i \
		-e '/CONFIGURATIONS/s:CONFIGURATIONS Release.*::' \
		CMake/Utils/OgreConfigTargets.cmake || die

	# make sure we're not using the included tinyxml
	# Update for 1.10.11: Unfortunately the build system does not
	#   search for a system wide tinyxml at this moment. However,
	#   TinyXML is meant to be built into and not linked to a using
	#   project anyway.
	# rm -f Tools/XMLConverter/{include,src}/tiny*.*

	# Fix some path issues
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DOGRE_BUILD_COMPONENT_JAVA=NO
		-DOGRE_BUILD_COMPONENT_PYTHON=NO
		-DOGRE_BUILD_DEPENDENCIES=NO
		-DOGRE_BUILD_PLUGIN_CG=$(usex cg)
		-DOGRE_BUILD_SAMPLES=$(usex examples)
		-DOGRE_BUILD_TESTS=FALSE
		-DOGRE_BUILD_TOOLS=$(usex tools)
		-DOGRE_CONFIG_DOUBLE=$(usex double-precision)
		-DOGRE_CONFIG_ENABLE_FREEIMAGE=$(usex freeimage)
		-DOGRE_CONFIG_THREADS=3
		-DOGRE_CONFIG_THREAD_PROVIDER=std
		-DOGRE_FULL_RPATH=NO
		-DOGRE_INSTALL_DOCS=$(usex doc)
		-DOGRE_INSTALL_SAMPLES=$(usex examples)
		-DOGRE_INSTALL_SAMPLES_SOURCE=$(usex examples)
		-DOGRE_NODE_STORAGE_LEGACY=NO
		-DOGRE_PROFILING=$(usex profile)
		-DOGRE_RESOURCEMANAGER_STRICT=strict
		-DOGRE_USE_STD11=YES
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	CONFIGDIR=/etc/OGRE
	SHAREDIR=/usr/share/OGRE

	# plugins and resources are the main configuration
	insinto "${CONFIGDIR}"
	doins "${CMAKE_BUILD_DIR}"/bin/plugins.cfg
	doins "${CMAKE_BUILD_DIR}"/bin/resources.cfg
	dosym "${CONFIGDIR}"/plugins.cfg "${SHAREDIR}"/plugins.cfg
	dosym "${CONFIGDIR}"/resources.cfg "${SHAREDIR}"/resources.cfg

	# These are only for the sample browser
	insinto "${SHAREDIR}"
	doins "${CMAKE_BUILD_DIR}"/bin/quakemap.cfg
	doins "${CMAKE_BUILD_DIR}"/bin/samples.cfg
}
