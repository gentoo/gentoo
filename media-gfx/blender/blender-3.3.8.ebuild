# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 python3_11 )

inherit check-reqs cmake flag-o-matic pax-utils python-single-r1 toolchain-funcs xdg-utils

DESCRIPTION="3D Creation/Animation/Publishing System"
HOMEPAGE="https://www.blender.org"

if [[ ${PV} = *9999* ]] ; then
	# Subversion is needed for downloading unit test files
	inherit git-r3 subversion
	EGIT_REPO_URI="https://git.blender.org/blender.git"
else
	SRC_URI="https://download.blender.org/source/${P}.tar.xz"
	# Update these between major releases.
	TEST_TARBALL_VERSION="$(ver_cut 1-2).0"
	#SRC_URI+=" test? ( https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${PN}-${TEST_TARBALL_VERSION}-tests.tar.xz )"
	KEYWORDS="~amd64 ~arm ~arm64"
fi

SLOT="${PV%.*}"
LICENSE="|| ( GPL-3 BL )"
IUSE="+bullet +dds +fluid +openexr +tbb \
	alembic collada +color-management cuda +cycles \
	debug doc +embree +ffmpeg +fftw +gmp headless jack jemalloc jpeg2k \
	man +nanovdb ndof nls openal +oidn +openimageio +openmp +opensubdiv \
	+openvdb optix osl +pdf +potrace +pugixml pulseaudio sdl +sndfile \
	test +tiff valgrind"
RESTRICT="!test? ( test ) test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	alembic? ( openexr )
	cuda? ( cycles )
	cycles? ( openexr tiff openimageio )
	fluid? ( tbb )
	openvdb? ( tbb )
	optix? ( cuda )
	osl? ( cycles )
	test? ( color-management )"

# Library versions for official builds can be found in the blender source directory in:
# build_files/build_environment/install_deps.sh
RDEPEND="${PYTHON_DEPS}
	dev-libs/boost:=[nls?]
	dev-libs/lzo:2=
	$(python_gen_cond_dep '
		dev-python/cython[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/zstandard[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	')
	media-libs/freetype:=[brotli]
	media-libs/glew:*
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/libsamplerate
	sys-libs/zlib:=
	virtual/glu
	virtual/libintl
	virtual/opengl
	alembic? ( >=media-gfx/alembic-1.8.3-r2[boost(+),hdf(+)] )
	collada? ( >=media-libs/opencollada-1.6.68 )
	color-management? ( >=media-libs/opencolorio-2.1.1-r7:= )
	cuda? ( dev-util/nvidia-cuda-toolkit:= )
	embree? ( >=media-libs/embree-3.10.0[raymask] )
	ffmpeg? ( media-video/ffmpeg:=[x264,mp3,encode,theora,jpeg2k?,vpx,vorbis,opus,xvid] )
	fftw? ( sci-libs/fftw:3.0= )
	gmp? ( dev-libs/gmp )
	!headless? (
		x11-libs/libX11
		x11-libs/libXi
		x11-libs/libXxf86vm
	)
	jack? ( virtual/jack )
	jemalloc? ( dev-libs/jemalloc:= )
	jpeg2k? ( media-libs/openjpeg:2= )
	ndof? (
		app-misc/spacenavd
		dev-libs/libspnav
	)
	nls? ( virtual/libiconv )
	openal? ( media-libs/openal )
	oidn? ( >=media-libs/oidn-1.4.1 )
	openimageio? ( >=media-libs/openimageio-2.3.12.0-r3:= )
	openexr? (
		>=dev-libs/imath-3.1.4-r2:=
		>=media-libs/openexr-3:0=
	)
	opensubdiv? ( >=media-libs/opensubdiv-3.4.0 )
	openvdb? (
		>=media-gfx/openvdb-9.0.0:=[nanovdb?]
		dev-libs/c-blosc:=
	)
	optix? ( <dev-libs/optix-7.5.0 )
	osl? ( >=media-libs/osl-1.11.16.0-r3:= )
	pdf? ( media-libs/libharu )
	potrace? ( media-gfx/potrace )
	pugixml? ( dev-libs/pugixml )
	pulseaudio? ( media-libs/libpulse )
	sdl? ( media-libs/libsdl2[sound,joystick] )
	sndfile? ( media-libs/libsndfile )
	tbb? ( dev-cpp/tbb:= )
	tiff? ( media-libs/tiff:= )
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

PATCHES=(
	"${FILESDIR}"/${PN}-3.2.2-support-building-with-musl-libc.patch
	"${FILESDIR}"/${PN}-3.2.2-Cycles-add-option-to-specify-OptiX-runtime-root-dire.patch
	"${FILESDIR}"/${PN}-3.2.2-Fix-T100845-wrong-Cycles-OptiX-runtime-compilation-i.patch
	"${FILESDIR}"/${PN}-3.3.0-fix-build-with-boost-1.81.patch
)

blender_check_requirements() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp

	if use doc; then
		CHECKREQS_DISK_BUILD="4G" check-reqs_pkg_pretend
	fi
}

blender_get_version() {
	# Get blender version from blender itself.
	BV=$(grep "BLENDER_VERSION " source/blender/blenkernel/BKE_blender_version.h | cut -d " " -f 3; assert)
	if ((${BV:0:1} < 3)) ; then
		# Add period (290 -> 2.90).
		BV=${BV:0:1}.${BV:1}
	else
		# Add period and skip the middle number (301 -> 3.1)
		BV=${BV:0:1}.${BV:2}
	fi
}

pkg_pretend() {
	blender_check_requirements
}

pkg_setup() {
	blender_check_requirements
	python-single-r1_pkg_setup
}

src_unpack() {
	if [[ ${PV} = *9999* ]] ; then
		git-r3_src_unpack
		if use test; then
			TESTS_SVN_URL=https://svn.blender.org/svnroot/bf-blender/trunk/lib/tests
			subversion_fetch ${TESTS_SVN_URL} ../lib/tests
		fi
	else
		default
		if use test; then
			#The tests are downloaded from: https://svn.blender.org/svnroot/bf-blender/tags/blender-${SLOT}-release/lib/tests
			mkdir -p lib || die
			mv "${WORKDIR}"/blender-${TEST_TARBALL_VERSION}-tests/tests lib || die
		fi
	fi

}

src_prepare() {
	cmake_src_prepare

	blender_get_version

	# Disable MS Windows help generation. The variable doesn't do what it
	# it sounds like.
	sed -e "s|GENERATE_HTMLHELP      = YES|GENERATE_HTMLHELP      = NO|" \
		-i doc/doxygen/Doxyfile || die

	# Prepare icons and .desktop files for slotting.
	sed -e "s|blender.svg|blender-${BV}.svg|" -i source/creator/CMakeLists.txt || die
	sed -e "s|blender-symbolic.svg|blender-${BV}-symbolic.svg|" -i source/creator/CMakeLists.txt || die
	sed -e "s|blender.desktop|blender-${BV}.desktop|" -i source/creator/CMakeLists.txt || die

	sed -e "s|Name=Blender|Name=Blender ${PV}|" -i release/freedesktop/blender.desktop || die
	sed -e "s|Exec=blender|Exec=blender-${BV}|" -i release/freedesktop/blender.desktop || die
	sed -e "s|Icon=blender|Icon=blender-${BV}|" -i release/freedesktop/blender.desktop || die

	mv release/freedesktop/icons/scalable/apps/blender.svg release/freedesktop/icons/scalable/apps/blender-${BV}.svg || die
	mv release/freedesktop/icons/symbolic/apps/blender-symbolic.svg release/freedesktop/icons/symbolic/apps/blender-${BV}-symbolic.svg || die
	mv release/freedesktop/blender.desktop release/freedesktop/blender-${BV}.desktop || die

	if use test; then
		# Without this the tests will try to use /usr/bin/blender and /usr/share/blender/ to run the tests.
		sed -e "s|string(REPLACE.*|set(TEST_INSTALL_DIR ${ED}/usr/)|g" -i tests/CMakeLists.txt || die
		sed -e "s|string(REPLACE.*|set(TEST_INSTALL_DIR ${ED}/usr/)|g" -i build_files/cmake/Modules/GTestTesting.cmake || die
	fi
}

src_configure() {
	append-lfs-flags

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
		-DWITH_CYCLES=$(usex cycles)
		-DWITH_CYCLES_DEVICE_CUDA=$(usex cuda TRUE FALSE)
		-DWITH_CYCLES_DEVICE_OPTIX=$(usex optix)
		-DWITH_CYCLES_EMBREE=$(usex embree)
		-DWITH_CYCLES_OSL=$(usex osl)
		-DWITH_CYCLES_STANDALONE=OFF
		-DWITH_CYCLES_STANDALONE_GUI=OFF
		-DWITH_DOC_MANPAGE=$(usex man)
		-DWITH_FFTW3=$(usex fftw)
		-DWITH_GMP=$(usex gmp)
		-DWITH_GTESTS=$(usex test)
		-DWITH_HARU=$(usex pdf)
		-DWITH_HEADLESS=$(usex headless)
		-DWITH_INSTALL_PORTABLE=OFF
		-DWITH_IMAGE_DDS=$(usex dds)
		-DWITH_IMAGE_OPENEXR=$(usex openexr)
		-DWITH_IMAGE_OPENJPEG=$(usex jpeg2k)
		-DWITH_IMAGE_TIFF=$(usex tiff)
		-DWITH_INPUT_NDOF=$(usex ndof)
		-DWITH_INTERNATIONAL=$(usex nls)
		-DWITH_JACK=$(usex jack)
		-DWITH_MEM_JEMALLOC=$(usex jemalloc)
		-DWITH_MEM_VALGRIND=$(usex valgrind)
		-DWITH_MOD_FLUID=$(usex fluid)
		-DWITH_MOD_OCEANSIM=$(usex fftw)
		-DWITH_NANOVDB=$(usex nanovdb)
		-DWITH_OPENAL=$(usex openal)
		-DWITH_OPENCOLLADA=$(usex collada)
		-DWITH_OPENCOLORIO=$(usex color-management)
		-DWITH_OPENIMAGEDENOISE=$(usex oidn)
		-DWITH_OPENIMAGEIO=$(usex openimageio)
		-DWITH_OPENMP=$(usex openmp)
		-DWITH_OPENSUBDIV=$(usex opensubdiv)
		-DWITH_OPENVDB=$(usex openvdb)
		-DWITH_OPENVDB_BLOSC=$(usex openvdb)
		-DWITH_POTRACE=$(usex potrace)
		-DWITH_PUGIXML=$(usex pugixml)
		-DWITH_PULSEAUDIO=$(usex pulseaudio)
		-DWITH_PYTHON_INSTALL=OFF
		-DWITH_SDL=$(usex sdl)
		-DWITH_STATIC_LIBS=OFF
		-DWITH_SYSTEM_EIGEN3=ON
		-DWITH_SYSTEM_FREETYPE=ON
		-DWITH_SYSTEM_GLEW=ON
		-DWITH_SYSTEM_LZO=ON
		-DWITH_TBB=$(usex tbb)
		-DWITH_USD=OFF
		-DWITH_XR_OPENXR=OFF
	)

	if use optix; then
		mycmakeargs+=(
			-DCYCLES_RUNTIME_OPTIX_ROOT_DIR="${EPREFIX}"/opt/optix
			-DOPTIX_ROOT_DIR="${EPREFIX}"/opt/optix
		)
	fi

	# This is currently needed on arm64 to get the NEON SIMD wrapper to compile the code successfully
	use arm64 && append-flags -flax-vector-conversions

	append-flags $(usex debug '-DDEBUG' '-DNDEBUG')

	if tc-is-gcc ; then
		# These options only exist when GCC is detected.
		# We disable these to respect the user's choice of linker.
		mycmakeargs+=(
			-DWITH_LINKER_GOLD=OFF
			-DWITH_LINKER_LLD=OFF
		)
	fi

	cmake_src_configure
}

src_test() {
	# A lot of tests needs to have access to the installed data files.
	# So install them into the image directory now.
	cmake_src_install

	blender_get_version
	# Define custom blender data/script file paths not be able to find them otherwise during testing.
	# (Because the data is in the image directory and it will default to look in /usr/share)
	export BLENDER_SYSTEM_SCRIPTS="${ED}"/usr/share/blender/${BV}/scripts
	export BLENDER_SYSTEM_DATAFILES="${ED}"/usr/share/blender/${BV}/datafiles

	# Sanity check that the script and datafile path is valid.
	# If they are not vaild, blender will fallback to the default path which is not what we want.
	[ -d "$BLENDER_SYSTEM_SCRIPTS" ] || die "The custom script path is invalid, fix the ebuild!"
	[ -d "$BLENDER_SYSTEM_DATAFILES" ] || die "The custom datafiles path is invalid, fix the ebuild!"

	cmake_src_test

	# Clean up the image directory for src_install
	rm -fr "${ED}"/* || die
}

src_install() {
	blender_get_version

	# Pax mark blender for hardened support.
	pax-mark m "${BUILD_DIR}"/bin/blender

	cmake_src_install

	if use man; then
		# Slot the man page
		mv "${ED}/usr/share/man/man1/blender.1" "${ED}/usr/share/man/man1/blender-${BV}.1" || die
	fi

	if use doc; then
		# Define custom blender data/script file paths. Otherwise Blender will not be able to find them during doc building.
		# (Because the data is in the image directory and it will default to look in /usr/share)
		export BLENDER_SYSTEM_SCRIPTS=${ED}/usr/share/blender/${BV}/scripts
		export BLENDER_SYSTEM_DATAFILES=${ED}/usr/share/blender/${BV}/datafiles

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

		docinto "html/API/python"
		dodoc -r "${CMAKE_USE_DIR}"/doc/python_api/BPY_API/.

		docinto "html/API/blender"
		dodoc -r "${CMAKE_USE_DIR}"/doc/doxygen/html/.
	fi

	# Fix doc installdir
	docinto html
	dodoc "${CMAKE_USE_DIR}"/release/text/readme.html
	rm -r "${ED}"/usr/share/doc/blender || die

	python_optimize "${ED}/usr/share/blender/${BV}/scripts"

	mv "${ED}/usr/bin/blender-thumbnailer" "${ED}/usr/bin/blender-${BV}-thumbnailer" || die
	mv "${ED}/usr/bin/blender" "${ED}/usr/bin/blender-${BV}" || die
}

pkg_postinst() {
	elog
	elog "Blender uses python integration. As such, may have some"
	elog "inherent risks with running unknown python scripts."
	elog
	elog "It is recommended to change your blender temp directory"
	elog "from /tmp to /home/user/tmp or another tmp file under your"
	elog "home directory. This can be done by starting blender, then"
	elog "changing the 'Temporary Files' directory in Blender preferences."
	elog

	if use osl; then
		ewarn ""
		ewarn "OSL is know to cause runtime segfaults if Mesa has been linked to"
		ewarn "an other LLVM version than what OSL is linked to."
		ewarn "See https://bugs.gentoo.org/880671 for more details"
		ewarn ""
	fi

	if ! use python_single_target_python3_10; then
		elog "You are building Blender with a newer python version than"
		elog "supported by this version upstream."
		elog "If you experience breakages with e.g. plugins, please switch to"
		elog "python_single_target_python3_10 instead."
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
	ewarn "~/.config/${PN}/${SLOT}/cache/"
	ewarn "It may contain extra render kernels not tracked by portage"
	ewarn ""
}
