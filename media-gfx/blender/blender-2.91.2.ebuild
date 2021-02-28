# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit check-reqs cmake flag-o-matic pax-utils python-single-r1 \
	toolchain-funcs xdg-utils

DESCRIPTION="3D Creation/Animation/Publishing System"
HOMEPAGE="https://www.blender.org"
SRC_URI="https://download.blender.org/source/${P}.tar.xz"

# Blender can have letters in the version string,
# so strip off the letter if it exists.
MY_PV="$(ver_cut 1-2)"

SLOT="0"
LICENSE="|| ( GPL-2 BL )"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+bullet +dds +elbeem +openexr +system-python +system-numpy +tbb \
	abi6-compat abi7-compat alembic collada color-management cuda cycles \
	debug doc ffmpeg fftw headless jack jemalloc jpeg2k llvm \
	man ndof nls openal opencl openimageio openmp opensubdiv \
	openvdb osl sdl sndfile standalone test tiff valgrind"
RESTRICT="!test? ( test )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	alembic? ( openexr )
	cuda? ( cycles )
	cycles? ( openexr tbb tiff openimageio )
	elbeem? ( tbb )
	opencl? ( cycles )
	openvdb? (
		^^ ( abi6-compat abi7-compat )
		tbb
	)
	osl? ( cycles llvm )
	standalone? ( cycles )"

RDEPEND="${PYTHON_DEPS}
	dev-libs/boost:=[nls?,threads(+)]
	dev-libs/gmp
	dev-libs/pugixml
	dev-libs/lzo:2=
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	')
	media-gfx/potrace
	media-libs/fontconfig:=
	media-libs/freetype:=
	media-libs/glew:*
	media-libs/libpng:=
	media-libs/libsamplerate
	sys-libs/zlib:=
	virtual/glu
	virtual/jpeg
	virtual/libintl
	virtual/opengl
	alembic? ( >=media-gfx/alembic-1.7.12[boost(+),hdf(+)] )
	collada? ( >=media-libs/opencollada-1.6.68 )
	color-management? ( media-libs/opencolorio )
	cuda? ( dev-util/nvidia-cuda-toolkit:= )
	cycles? ( media-libs/freeglut )
	ffmpeg? ( media-video/ffmpeg:=[x264,mp3,encode,theora,jpeg2k?] )
	fftw? ( sci-libs/fftw:3.0= )
	!headless? (
		x11-libs/libX11
		x11-libs/libXi
		x11-libs/libXxf86vm
	)
	jack? ( virtual/jack )
	jemalloc? ( dev-libs/jemalloc:= )
	jpeg2k? ( media-libs/openjpeg:2= )
	llvm? ( sys-devel/llvm:= )
	ndof? (
		app-misc/spacenavd
		dev-libs/libspnav
	)
	nls? ( virtual/libiconv )
	openal? ( media-libs/openal )
	opencl? ( virtual/opencl )
	openimageio? ( media-libs/openimageio:= )
	openexr? (
		media-libs/ilmbase:=
		media-libs/openexr:=
	)
	opensubdiv? ( >=media-libs/opensubdiv-3.4.0[cuda=,opencl=] )
	openvdb? (
		~media-gfx/openvdb-7.0.0[abi6-compat(-)?,abi7-compat(-)?]
		dev-libs/c-blosc:=
	)
	osl? ( media-libs/osl:= )
	sdl? ( media-libs/libsdl2[sound,joystick] )
	sndfile? ( media-libs/libsndfile )
	tbb? ( dev-cpp/tbb )
	tiff? ( media-libs/tiff )
	valgrind? ( dev-util/valgrind )
"

DEPEND="${RDEPEND}
	dev-cpp/eigen:=
"

BDEPEND="
	virtual/pkgconfig
	doc? (
		app-doc/doxygen[dot]
		dev-python/sphinx[latex]
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
	nls? ( sys-devel/gettext )
"

CMAKE_BUILD_TYPE="Release"

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
	cmake_src_prepare

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

	if use openvdb; then
		local version
		if use abi6-compat; then
			version=6;
		elif use abi7-compat; then
			version=7;
		else
			die "Openvdb abi version not compatible"
		fi
		append-cppflags -DOPENVDB_ABI_VERSION_NUMBER=${version}
	fi

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DPYTHON_LIBRARY="$(python_get_library_path)"
		-DPYTHON_VERSION="${EPYTHON/python/}"
		-DWITH_ALEMBIC=$(usex alembic)
		-DWITH_ASSERT_ABORT=$(usex debug)
		-DWITH_BOOST=ON
		-DWITH_BULLET=$(usex bullet)
		-DWITH_CODEC_FFMPEG=$(usex ffmpeg)
		-DWITH_CODEC_SNDFILE=$(usex sndfile)
		-DWITH_CXX_GUARDEDALLOC=$(usex debug)
		-DWITH_CYCLES_DEVICE_CUDA=$(usex cuda TRUE FALSE)
		-DWITH_CYCLES=$(usex cycles)
		-DWITH_CYCLES_DEVICE_OPENCL=$(usex opencl)
		-DWITH_CYCLES_EMBREE=OFF
		-DWITH_CYCLES_STANDALONE=$(usex standalone)
		-DWITH_CYCLES_STANDALONE_GUI=$(usex standalone)
		-DWITH_CYCLES_OSL=$(usex osl)
		-DWITH_DOC_MANPAGE=$(usex man)
		-DWITH_FFTW3=$(usex fftw)
		-DWITH_GHOST_X11=$(usex !headless)
		-DWITH_GTESTS=$(usex test)
		-DWITH_HEADLESS=$(usex headless)
		-DWITH_INSTALL_PORTABLE=OFF
		-DWITH_IMAGE_DDS=$(usex dds)
		-DWITH_IMAGE_OPENEXR=$(usex openexr)
		-DWITH_IMAGE_OPENJPEG=$(usex jpeg2k)
		-DWITH_IMAGE_TIFF=$(usex tiff)
		-DWITH_INPUT_NDOF=$(usex ndof)
		-DWITH_INTERNATIONAL=$(usex nls)
		-DWITH_JACK=$(usex jack)
		-DWITH_LLVM=$(usex llvm)
		-DWITH_MEM_JEMALLOC=$(usex jemalloc)
		-DWITH_MEM_VALGRIND=$(usex valgrind)
		-DWITH_MOD_FLUID=$(usex elbeem)
		-DWITH_MOD_OCEANSIM=$(usex fftw)
		-DWITH_OPENAL=$(usex openal)
		-DWITH_OPENCOLLADA=$(usex collada)
		-DWITH_OPENCOLORIO=$(usex color-management)
		-DWITH_OPENIMAGEIO=$(usex openimageio)
		-DWITH_OPENMP=$(usex openmp)
		-DWITH_OPENSUBDIV=$(usex opensubdiv)
		-DWITH_OPENVDB=$(usex openvdb)
		-DWITH_OPENVDB_BLOSC=$(usex openvdb)
		-DWITH_PYTHON_INSTALL=$(usex system-python OFF ON)
		-DWITH_PYTHON_INSTALL_NUMPY=$(usex system-numpy OFF ON)
		-DWITH_SDL=$(usex sdl)
		-DWITH_STATIC_LIBS=OFF
		-DWITH_SYSTEM_EIGEN3=ON
		-DWITH_SYSTEM_GLEW=ON
		-DWITH_SYSTEM_LZO=ON
		-DWITH_TBB=$(usex tbb)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc; then
		# Workaround for binary drivers.
		addpredict /dev/ati
		addpredict /dev/dri
		addpredict /dev/nvidiactl

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
	pax-mark m "${BUILD_DIR}"/bin/blender

	if use standalone; then
		dobin "${BUILD_DIR}"/bin/cycles
	fi

	if use doc; then
		docinto "html/API/python"
		dodoc -r "${CMAKE_USE_DIR}"/doc/python_api/BPY_API/.

		docinto "html/API/blender"
		dodoc -r "${CMAKE_USE_DIR}"/doc/doxygen/html/.
	fi

	cmake_src_install

	# fix doc installdir
	docinto "html"
	dodoc "${CMAKE_USE_DIR}"/release/text/readme.html
	rm -r "${ED}"/usr/share/doc/blender || die

	python_fix_shebang "${ED}/usr/bin/blender-thumbnailer.py"
	python_optimize "${ED}/usr/share/blender/${MY_PV}/scripts"
}

pkg_postinst() {
	elog
	elog "Blender uses python integration. As such, may have some"
	elog "inherent risks with running unknown python scripts."
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

	if use python_single_target_python3_8; then
		elog "You've enabled python-3.8 support for blender, which is still experimental."
		elog "If you experience breakages with e.g. plugins, please switch to"
		elog "python_single_target_python3_7 instead."
		elog "Bug: https://bugs.gentoo.org/737388"
		elog
	fi

	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update

	ewarn ""
	ewarn "You may want to remove the following directory."
	ewarn "~/.config/${PN}/${MY_PV}/cache/"
	ewarn "It may contain extra render kernels not tracked by portage"
	ewarn ""
}
