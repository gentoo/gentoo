# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python3_5 )

inherit check-reqs cmake-utils fdo-mime flag-o-matic gnome2-utils \
	pax-utils python-single-r1 toolchain-funcs versionator

DESCRIPTION="3D Creation/Animation/Publishing System"
HOMEPAGE="http://www.blender.org"

SRC_URI="http://download.blender.org/source/${P}.tar.gz"

# Blender can have letters in the version string,
# so strip of the letter if it exists.
MY_PV="$(get_version_component_range 1-2)"

SLOT="0"
LICENSE="|| ( GPL-2 BL )"
KEYWORDS="~amd64 ~x86"
IUSE="+boost +bullet +dds +elbeem +game-engine +openexr collada colorio \
	cuda cycles debug doc ffmpeg fftw headless jack jemalloc jpeg2k libav \
	llvm man ndof nls openal opencl openimageio openmp opensubdiv openvdb \
	openvdb-compression player sdl sndfile test tiff valgrind"

# OpenCL and nVidia performance is rubbish with Blender
# If you have nVidia, use CUDA.
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	player? ( game-engine !headless )
	cuda? ( cycles !opencl )
	cycles? ( boost openexr tiff openimageio )
	colorio? ( boost )
	openvdb? ( boost )
	opensubdiv? ( cuda )
	nls? ( boost )
	openal? ( boost )
	opencl? ( cycles )
	game-engine? ( boost )
	?? ( ffmpeg libav )"

# Since not using OpenCL with nVidia, depend on ATI binary
# blobs as Cycles with OpenCL does not work with any open
# source drivers.
COMMON_DEPEND="
	boost? ( >=dev-libs/boost-1.62:=[nls?,threads(+)] )
	collada? ( >=media-libs/opencollada-1.6.18:= )
	colorio? ( >=media-libs/opencolorio-1.0.9-r2 )
	cuda? ( dev-util/nvidia-cuda-toolkit:= )
	ffmpeg? ( media-video/ffmpeg:=[x264,mp3,encode,theora,jpeg2k?] )
	libav? ( >=media-video/libav-11.3:=[x264,mp3,encode,theora,jpeg2k?] )
	fftw? ( sci-libs/fftw:3.0= )
	!headless? (
		x11-libs/libX11
		x11-libs/libXi
		x11-libs/libXxf86vm
	)
	jack? ( media-sound/jack-audio-connection-kit )
	jemalloc? ( dev-libs/jemalloc:= )
	jpeg2k? ( media-libs/openjpeg:0 )
	llvm? ( sys-devel/llvm )
	ndof? (
		app-misc/spacenavd
		dev-libs/libspnav
	)
	nls? ( virtual/libiconv )
	openal? ( media-libs/openal )
	openimageio? ( >=media-libs/openimageio-1.6.9 )
	opencl? ( x11-drivers/ati-drivers:* )
	openexr? (
		>=media-libs/ilmbase-2.2.0:=
		>=media-libs/openexr-2.2.0:=
	)
	opensubdiv? ( media-libs/opensubdiv[cuda=,opencl=] )
	openvdb? (
		media-gfx/openvdb[${PYTHON_USEDEP},openvdb-compression=]
		dev-cpp/tbb
	)
	openvdb-compression? ( >=dev-libs/c-blosc-1.5.2 )
	sdl? ( media-libs/libsdl2[sound,joystick] )
	sndfile? ( media-libs/libsndfile )
	tiff? ( media-libs/tiff:0 )
	valgrind? ( dev-util/valgrind )"

RDEPEND="${PYTHON_DEPS}
	dev-libs/lzo:2
	>=dev-python/numpy-1.10.1[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	media-libs/freetype
	media-libs/glew:*
	media-libs/libpng:0=
	media-libs/libsamplerate
	sys-libs/zlib
	virtual/glu
	virtual/jpeg:0=
	virtual/libintl
	virtual/opengl
	${COMMON_DEPEND}"

DEPEND="${RDEPEND}
	>=dev-cpp/eigen-3.2.8:3
	doc? (
		app-doc/doxygen[-nodot(-),dot(+),latex]
		dev-python/sphinx[latex]
	)
	nls? ( sys-devel/gettext )
	${COMMON_DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-C++11-build-fix.patch
	  "${FILESDIR}"/${PN}-fix-install-rules.patch )

blender_check_requirements() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp

	if use doc; then
		CHECKREQS_DISK_BUILD="4G" check-reqs_pkg_pretend
	fi
}

pkg_pretend() {
	blender_check_requirements
}

pkg_setup() {
	blender_check_requirements
	python-single-r1_pkg_setup
}

src_prepare() {
	default

	# we don't want static glew, but it's scattered across
	# multiple files that differ from version to version
	# !!!CHECK THIS SED ON EVERY VERSION BUMP!!!
	local file
	while IFS="" read -d $'\0' -r file ; do
		sed -i -e '/-DGLEW_STATIC/d' "${file}" || die
	done < <(find . -type f -name "CMakeLists.txt")

	# Disable MS Windows help generation. The variable doesn't do what it
	# it sounds like.
	sed -e "s|GENERATE_HTMLHELP      = YES|GENERATE_HTMLHELP      = NO|" \
	    -i doc/doxygen/Doxyfile || die
}

src_configure() {
	# FIX: forcing '-funsigned-char' fixes an anti-aliasing issue with menu
	# shadows, see bug #276338 for reference
	append-flags -funsigned-char
	append-lfs-flags

	local mycmakeargs=(
		-DPYTHON_VERSION="${EPYTHON/python/}"
		-DPYTHON_LIBRARY="$(python_get_library_path)"
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DWITH_INSTALL_PORTABLE=OFF
		-DWITH_PYTHON_INSTALL=OFF
		-DWITH_PYTHON_INSTALL_NUMPY=OFF
		-DWITH_STATIC_LIBS=OFF
		-DWITH_SYSTEM_GLEW=ON
		-DWITH_SYSTEM_OPENJPEG=ON
		-DWITH_SYSTEM_EIGEN3=ON
		-DWITH_SYSTEM_LZO=ON
		-DWITH_C11=ON
		-DWITH_CXX11=ON
		-DWITH_BOOST=$(usex boost)
		-DWITH_BULLET=$(usex bullet)
		-DWITH_CODEC_FFMPEG=$(usex ffmpeg)
		-DWITH_CODEC_SNDFILE=$(usex sndfile)
		-DWITH_CUDA=$(usex cuda)
		-DWITH_CYCLES_DEVICE_CUDA=$(usex cuda TRUE FALSE)
		-DWITH_CYCLES=$(usex cycles)
		-DWITH_CYCLES_OSL=OFF
		-DWITH_LLVM=$(usex llvm)
		-DWITH_FFTW3=$(usex fftw)
		-DWITH_GAMEENGINE=$(usex game-engine)
		-DWITH_HEADLESS=$(usex headless)
		-DWITH_X11=$(usex !headless)
		-DWITH_IMAGE_DDS=$(usex dds)
		-DWITH_IMAGE_OPENEXR=$(usex openexr)
		-DWITH_IMAGE_OPENJPEG=$(usex jpeg2k)
		-DWITH_IMAGE_TIFF=$(usex tiff)
		-DWITH_INPUT_NDOF=$(usex ndof)
		-DWITH_INTERNATIONAL=$(usex nls)
		-DWITH_JACK=$(usex jack)
		-DWITH_MOD_FLUID=$(usex elbeem)
		-DWITH_MOD_OCEANSIM=$(usex fftw)
		-DWITH_OPENAL=$(usex openal)
		-DWITH_OPENCL=$(usex opencl)
		-DWITH_CYCLES_DEVICE_OPENCL=$(usex opencl TRUE FALSE)
		-DWITH_OPENCOLORIO=$(usex colorio)
		-DWITH_OPENCOLLADA=$(usex collada)
		-DWITH_OPENIMAGEIO=$(usex openimageio)
		-DWITH_OPENMP=$(usex openmp)
		-DWITH_OPENSUBDIV=$(usex opensubdiv)
		-DWITH_OPENVDB=$(usex openvdb)
		-DWITH_OPENVDB_BLOSC=$(usex openvdb-compression)
		-DWITH_PLAYER=$(usex player)
		-DWITH_SDL=$(usex sdl)
		-DWITH_CXX_GUARDEDALLOC=$(usex debug)
		-DWITH_ASSERT_ABORT=$(usex debug)
		-DWITH_GTESTS=$(usex test)
		-DWITH_DOC_MANPAGE=$(usex man)
		-DWITH_MEM_JEMALLOC=$(usex jemalloc)
		-DWITH_MEM_VALGRIND=$(usex valgrind)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	if use doc; then
		# Workaround for binary drivers.
		local card
		local cards=( /dev/ati/card* /dev/nvidia* )
		for card in "${cards[@]}"; do addpredict "${card}"; done

		einfo "Generating Blender C/C++ API docs ..."
		cd "${CMAKE_USE_DIR}"/doc/doxygen || die
		doxygen -u Doxyfile || die
		doxygen || die "doxygen failed to build API docs."

		cd "${CMAKE_USE_DIR}" || die
		einfo "Generating (BPY) Blender Python API docs ..."
		"${BUILD_DIR}"/bin/blender --background --python doc/python_api/sphinx_doc_gen.py -noaudio || die "sphinx failed."

		cd "${CMAKE_USE_DIR}"/doc/python_api || die
		sphinx-build sphinx-in BPY_API || die "sphinx failed."
	fi
}

src_test() {
	if use test; then
		einfo "Running Blender Unit Tests ..."
		cd "${BUILD_DIR}"/bin/tests || die
		local f
		for f in *_test; do
			./"${f}" || die
		done
	fi
}

src_install() {
	# Pax mark blender for hardened support.
	pax-mark m "${CMAKE_BUILD_DIR}"/bin/blender

	if use doc; then
		docinto "html/API/python"
		dodoc -r "${CMAKE_USE_DIR}"/doc/python_api/BPY_API/.

		docinto "html/API/blender"
		dodoc -r "${CMAKE_USE_DIR}"/doc/doxygen/html/.
	fi

	emake -C "${CMAKE_BUILD_DIR}" DESTDIR="${D}" install/fast

	# fix doc installdir
	docinto "html"
	dodoc "${CMAKE_USE_DIR}"/release/text/readme.html
	rm -r "${ED%/}"/usr/share/doc/blender || die

	python_fix_shebang "${ED%/}/usr/bin/blender-thumbnailer.py"
	python_optimize "${ED%/}/usr/share/blender/${MY_PV}/scripts"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	elog
	elog "Blender uses python integration. As such, may have some"
	elog "inherit risks with running unknown python scripts."
	elog
	elog "It is recommended to change your blender temp directory"
	elog "from /tmp to /home/user/tmp or another tmp file under your"
	elog "home directory. This can be done by starting blender, then"
	elog "dragging the main menu down do display all paths."
	elog
	ewarn
	ewarn "This ebuild does not unbundle the massive amount of 3rd party"
	ewarn "libraries which are shipped with blender. Note that"
	ewarn "these have caused security issues in the past."
	ewarn "If you are concerned about security, file a bug upstream:"
	ewarn "  https://developer.blender.org/"
	ewarn
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update

	ewarn ""
	ewarn "You may want to remove the following directory."
	ewarn "~/.config/${PN}/${MY_PV}/cache/"
	ewarn "It may contain extra render kernels not tracked by portage"
	ewarn ""
}
