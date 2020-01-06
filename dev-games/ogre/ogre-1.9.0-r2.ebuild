# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_REMOVE_MODULES_LIST="FindFreetype FindDoxygen FindZLIB"

inherit cmake vcs-snapshot

DESCRIPTION="Object-oriented Graphics Rendering Engine"
HOMEPAGE="https://www.ogre3d.org/"
SRC_URI="https://bitbucket.org/sinbad/ogre/get/v${PV//./-}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="MIT public-domain"
SLOT="0/1.9.0"
KEYWORDS="~amd64 ~arm ~x86"

# gles1 currently broken wrt bug #418201
# gles1 does not even build wrt bug #506058
IUSE="+boost cg doc double-precision examples +freeimage gl3plus gles2 gles3 ois +opengl poco profile tbb threads tools +zip"

REQUIRED_USE="threads? ( ^^ ( boost poco tbb ) )
	examples? ( ois )
	poco? ( threads )
	tbb? ( threads )
	gl3plus? ( !gles2 !gles3 )
	gles3? ( gles2 )
	gl3plus? ( opengl )"

RESTRICT="test" #139905

RDEPEND="
	media-libs/freetype:2
	virtual/opengl
	virtual/glu
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXrandr
	x11-libs/libXt
	boost? ( dev-libs/boost:= )
	cg? ( media-gfx/nvidia-cg-toolkit )
	freeimage? ( media-libs/freeimage )
	gles2? ( >=media-libs/mesa-9.0.0[gles2] )
	gles3? ( >=media-libs/mesa-10.0.0[gles2] )
	gl3plus? ( >=media-libs/mesa-9.2.5 )
	ois? ( dev-games/ois )
	threads? (
		poco? ( dev-libs/poco )
		tbb? ( dev-cpp/tbb )
	)
	tools? ( dev-libs/tinyxml[stl] )
	zip? ( sys-libs/zlib dev-libs/zziplib )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-base/xorg-proto
	doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}/${P}-remove_resource_path_to_bindir.patch"
	"${FILESDIR}/${P}-remove_media_path_to_bindir.patch"
	"${FILESDIR}/${P}-gcc52.patch"
	"${FILESDIR}/${P}-samples.patch"
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
	rm -f Tools/XMLConverter/{include,src}/tiny*.*

	# Fix some path issues
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DOGRE_FULL_RPATH=NO
		-DOGRE_USE_BOOST=$(usex boost)
		-DOGRE_BUILD_PLUGIN_CG=$(usex cg)
		-DOGRE_INSTALL_DOCS=$(usex doc)
		-DOGRE_CONFIG_DOUBLE=$(usex double-precision)
		-DOGRE_CONFIG_ENABLE_FREEIMAGE=$(usex freeimage)
		-DOGRE_BUILD_RENDERSYSTEM_GL=$(usex opengl)
		-DOGRE_BUILD_RENDERSYSTEM_GL3PLUS=$(usex gl3plus)
		-DOGRE_BUILD_RENDERSYSTEM_GLES=FALSE
		-DOGRE_BUILD_RENDERSYSTEM_GLES2=$(usex gles2)
		-DOGRE_CONFIG_ENABLE_GLES3_SUPPORT=$(usex gles3)
		-DOGRE_PROFILING=$(usex profile)
		-DOGRE_BUILD_SAMPLES=$(usex examples)
		-DOGRE_INSTALL_SAMPLES=$(usex examples)
		-DOGRE_INSTALL_SAMPLES_SOURCE=$(usex examples)
		-DOGRE_BUILD_TESTS=FALSE
		-DOGRE_CONFIG_THREADS=$(usex threads 2 0)
		-DOGRE_BUILD_TOOLS=$(usex tools)
		-DOGRE_CONFIG_ENABLE_ZIP=$(usex zip)
	)

	if use threads ; then
		local f
		for f in boost poco tbb ; do
			use ${f} || continue
			mycmakeargs+=( -DOGRE_CONFIG_THREAD_PROVIDER=${f} )
			break
		done
	fi

	cmake_src_configure
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
	insinto "${SHAREDIR}"
	doins "${BUILD_DIR}"/bin/quakemap.cfg
	doins "${BUILD_DIR}"/bin/samples.cfg
}
