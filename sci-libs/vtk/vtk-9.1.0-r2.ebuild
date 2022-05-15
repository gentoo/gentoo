# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# TODO:
# - add USE flag for remote modules? Those modules can be downloaded
#	properly before building.
# - replace usex by usev once we bump to EAPI 8

PYTHON_COMPAT=( python3_{8..10} )
WEBAPP_OPTIONAL=yes
WEBAPP_MANUAL_SLOT=yes

inherit check-reqs cmake cuda java-pkg-opt-2 python-single-r1 toolchain-funcs virtualx webapp

# Short package version
MY_PV="$(ver_cut 1-2)"

DESCRIPTION="The Visualization Toolkit"
HOMEPAGE="https://www.vtk.org/"
SRC_URI="
	https://www.vtk.org/files/release/${MY_PV}/VTK-${PV}.tar.gz
	https://www.vtk.org/files/release/${MY_PV}/VTKData-${PV}.tar.gz
	https://www.vtk.org/files/release/${MY_PV}/VTKDataFiles-${PV}.tar.gz
	doc? ( https://www.vtk.org/files/release/${MY_PV}/vtkDocHtml-${PV}.tar.gz )
	examples? (
		https://www.vtk.org/files/release/${MY_PV}/VTKLargeData-${PV}.tar.gz
		https://www.vtk.org/files/release/${MY_PV}/VTKLargeDataFiles-${PV}.tar.gz
	)
	test? (
		https://www.vtk.org/files/release/${MY_PV}/VTKLargeData-${PV}.tar.gz
		https://www.vtk.org/files/release/${MY_PV}/VTKLargeDataFiles-${PV}.tar.gz
	)
"
S="${WORKDIR}/VTK-${PV}"

LICENSE="BSD LGPL-2"
SLOT="0/${MY_PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"
# TODO: Like to simplifiy these. Mostly the flags related to Groups, plus
# maybe some flags related to Kits and a few other needed flags.
IUSE="all-modules +boost cuda debug doc examples +ffmpeg +gdal imaging java
	mpi mysql odbc openmp postgres python qt5 +rendering tbb test +threads
	tk video_cards_nvidia views web"

RESTRICT="!test? ( test )"

REQUIRED_USE="
	all-modules? ( boost ffmpeg gdal imaging mysql odbc postgres qt5 rendering views )
	cuda? ( video_cards_nvidia )
	java? ( rendering )
	python? ( ${PYTHON_REQUIRED_USE} )
	qt5? ( rendering )
	tk? ( rendering python )
	web? ( python )
"

RDEPEND="
	app-arch/lz4:=
	app-arch/xz-utils
	dev-db/sqlite:3
	dev-libs/double-conversion:=
	dev-libs/expat
	dev-libs/icu:=
	dev-libs/jsoncpp:=
	dev-libs/libxml2:2
	dev-libs/pugixml
	media-libs/freetype
	media-libs/libogg
	media-libs/libpng:=
	media-libs/libtheora
	media-libs/tiff
	sci-libs/hdf5:=[mpi=]
	sci-libs/netcdf:=[mpi=]
	sys-libs/zlib
	media-libs/libjpeg-turbo
	all-modules? ( sci-geosciences/liblas[gdal] )
	boost? ( dev-libs/boost:=[mpi?] )
	cuda? ( dev-util/nvidia-cuda-toolkit:= )
	ffmpeg? ( media-video/ffmpeg:= )
	gdal? ( sci-libs/gdal:= )
	java? ( >=virtual/jdk-1.8:* )
	mpi? (
		media-libs/glew:=
		virtual/mpi[cxx,romio]
		virtual/opengl
	)
	mysql? ( dev-db/mariadb-connector-c )
	odbc? ( dev-db/unixODBC )
	postgres? ( dev-db/postgresql:= )
	python? ( ${PYTHON_DEPS} )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtopengl:5
		dev-qt/qtquickcontrols2:5
		dev-qt/qtsql:5
		dev-qt/qtwidgets:5
	)
	rendering? (
		media-libs/freeglut
		media-libs/glew:=
		media-libs/libsdl2
		sci-libs/proj:=
		virtual/opengl
		x11-libs/gl2ps
		x11-libs/libXcursor
	)
	tbb? ( <dev-cpp/tbb-2021.4.0:= )
	tk? ( dev-lang/tk:= )
	video_cards_nvidia? ( x11-drivers/nvidia-drivers[tools,static-libs] )
	views? (
		x11-libs/libICE
		x11-libs/libXext
	)
	web? ( ${WEBAPP_DEPEND} )
	python? (
		$(python_gen_cond_dep '
			boost? ( dev-libs/boost:=[mpi?,python?,${PYTHON_USEDEP}] )
			mpi? ( dev-python/mpi4py[${PYTHON_USEDEP}] )
		')
		gdal? ( sci-libs/gdal:=[python?,${PYTHON_SINGLE_USEDEP}] )
	)
"

DEPEND="
	${RDEPEND}
	dev-cpp/eigen
	<dev-libs/pegtl-3
	dev-libs/utfcpp
"
BDEPEND="
	virtual/pkgconfig
	mpi? ( app-admin/chrpath )
	test? (
		media-libs/glew
		virtual/opengl
		x11-libs/libXcursor
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-9.0.1-0001-fix-kepler-compute_arch-if-CUDA-toolkit-11-is-used.patch
	"${FILESDIR}"/${PN}-8.2.0-freetype-2.10.3-provide-FT_CALLBACK_DEF.patch
	"${FILESDIR}"/${PN}-9.0.3-IO-FFMPEG-support-FFmpeg-5.0-API-changes.patch
	"${FILESDIR}"/${P}-adjust-to-find-binaries.patch
)

DOCS=( CONTRIBUTING.md README.md )

# based on default settings
CHECKREQS_DISK_BUILD="4G"
# we want the EAPI 8 default
CMAKE_BUILD_TYPE=RelWithDebInfo

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && has openmp && tc-check-openmp

	if [[ $(tc-is-gcc) && $(gcc-majorversion) = 11 ]] && use cuda ; then
		# FIXME: better use eerror?
		ewarn "GCC 11 is know to fail building with CUDA support in some cases."
		ewarn "See bug #820593"
	fi

	if use examples || use doc; then
		CHECKREQS_DISK_BUILD="7G"
	fi

	if use examples && use doc; then
		CHECKREQS_DISK_BUILD="10G"
	fi

	if use cuda; then
		# NOTE: This should actually equal to (number of build jobs)*7G,
		# as any of the cuda compile tasks can take up 7G!
		# 10.2 GiB install directory, 6.4 GiB build directory with max. USE flags
		CHECKREQS_MEMORY="7G"
		CHECKREQS_DISK_BUILD="14G"
	fi

	check-reqs_pkg_setup
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && has openmp && tc-check-openmp

	if [[ $(tc-is-gcc) && $(gcc-majorversion) = 11 ]] && use cuda ; then
		# FIXME: better use eerror?
		ewarn "GCC 11 is know to fail building with CUDA support in some cases."
		ewarn "See bug #820593"
	fi

	if use examples || use doc; then
		CHECKREQS_DISK_BUILD="7G"
	fi

	if use examples && use doc; then
			CHECKREQS_DISK_BUILD="10G"
	fi

	if use cuda; then
		CHECKREQS_MEMORY="7G"
		CHECKREQS_DISK_BUILD="14G"
	fi

	check-reqs_pkg_setup

	use java && java-pkg-opt-2_pkg_setup
	use python && python-single-r1_pkg_setup
	use web && webapp_pkg_setup
}

src_prepare() {
	# If we have system libraries available use these and delete
	# the respecting files in ${S}/ThirdParty to save some space.
	# Note: The following libraries are marked as internal by kitware
	#	and can currently not unbundled:
	#	diy2, exodusII, fides, h5part, kissfft, loguru, verdict, vpic,
	#	vtkm, xdmf{2,3}, zfp
	# Note: libharu is omitted: vtk needs an updated version (2.4.0)
	# Note: fmt is ommited, >=libfmt-8.1.0 needed
	# Note: cgns is ommited, >=cgnslib-4.1 needed
	# Note: no valid mpi4py target found with system library
	# TODO: cgns (4.1), cli11 (::guru), exprtk, ioss, libfmt (8.1.0)
	local -a DROPS=( doubleconversion eigen expat freetype hdf5 jpeg jsoncpp
		libxml2 lz4 lzma netcdf ogg pegtl png pugixml sqlite theora tiff utf8
		zlib )
	use rendering && DROPS+=( gl2ps glew libproj )

	local x
	for x in ${DROPS[@]}; do
		ebegin "Dropping bundled ${x}"
		rm -r ThirdParty/${x}/vtk${x} || die
		eend $?
	done
	unset x

	if use doc; then
		einfo "Removing .md5 files from documents."
		rm -f "${WORKDIR}"/html/*.md5 || die "Failed to remove superfluous hashes"
		sed -e "s|\${VTK_BINARY_DIR}/Utilities/Doxygen/doc|${WORKDIR}|" \
			-i Utilities/Doxygen/CMakeLists.txt || die
	fi

	cmake_src_prepare

	if use cuda; then
		cuda_add_sandbox -w
		cuda_src_prepare
	fi

	if use test; then
		ebegin "Copying data files to ${BUILD_DIR}"
		mkdir -p "${BUILD_DIR}/ExternalData" || die
		pushd "${BUILD_DIR}/ExternalData" >/dev/null || die
		ln -sf ../../VTK-${PV}/.ExternalData/README.rst . || die
		ln -sf ../../VTK-${PV}/.ExternalData/SHA512 . || die
		popd >/dev/null || die
		eend "$?"
	fi
}

src_configure() {
# TODO: check these and consider to use them
#	VTK_BUILD_SCALED_SOA_ARRAYS
#	VTK_DISPATCH_{AOS,SOA,TYPED}_ARRAYS

	local mycmakeargs=(
		-DVTK_ANDROID_BUILD=OFF
		-DVTK_IOS_BUILD=OFF

		-DVTK_BUILD_ALL_MODULES=$(usex all-modules ON OFF)
		# we use the pre-built documentation and install these with USE=doc
		-DVTK_BUILD_DOCUMENTATION=OFF
		-DVTK_BUILD_EXAMPLES=$(usex examples ON OFF)

		-DVTK_ENABLE_KITS=ON
		# defaults to ON: USE flag for this?
		-DVTK_ENABLE_REMOTE_MODULES=OFF

		-DVTK_GROUP_ENABLE_Imaging=$(usex imaging "YES" "DONT_WANT")
		-DVTK_GROUP_ENABLE_Qt=$(usex qt5 "YES" "DONT_WANT")
		-DVTK_GROUP_ENABLE_Rendering=$(usex rendering "YES" "DONT_WANT")
		-DVTK_GROUP_ENABLE_StandAlone="YES"
		-DVTK_GROUP_ENABLE_Views=$(usex views "YES" "DONT_WANT")
		-DVTK_GROUP_ENABLE_Web=$(usex web "YES" "DONT_WANT")

		-DVTK_INSTALL_SDK=ON

		-DVTK_MODULE_ENABLE_VTK_vtkm="WANT"
		-DVTK_MODULE_ENABLE_VTK_IOGeoJSON="WANT"
		-DVTK_MODULE_ENABLE_VTK_IOOggTheora="WANT"

		# TODO: update one cgnslib-4.1.1 is packaged
		-DVTK_MODULE_USE_EXTERNAL_VTK_cgns=OFF
		# not packaged in Gentoo
		-DVTK_MODULE_USE_EXTERNAL_VTK_exprtk=OFF
		# TODO: update once libfmt-8.1.0 has been packaged
		-DVTK_MODULE_USE_EXTERNAL_VTK_fmt=OFF
		# not pacakged in Gentoo
		-DVTK_MODULE_USE_EXTERNAL_VTK_ioss=OFF

		-DVTK_RELOCATABLE_INSTALL=ON

		-DVTK_SMP_ENABLE_OPENMP=$(usex openmp ON OFF)
		-DVTK_SMP_ENABLE_STDTHREAD=$(usex threads ON OFF)
		-DVTK_SMP_ENABLE_TBB=$(usex tbb ON OFF)

		-DVTK_USE_CUDA=$(usex cuda ON OFF)
		# use system libraries where possible
		-DVTK_USE_EXTERNAL=ON
		-DVTK_USE_MPI=$(usex mpi ON OFF)
		-DVTK_USE_TK=$(usex tk ON OFF)
		-DVTK_USE_X=ON

		-DVTK_WRAP_JAVA=$(usex java ON OFF)
		-DVTK_WRAP_PYTHON=$(usex python ON OFF)
	)

	if use all-modules; then
		mycmakeargs+=(
			-DVTK_ENABLE_OSPRAY=OFF
			# TODO: some of these are tied to the VTK_ENABLE_REMOTE_MODULES
			# option. Check whether we can download them clean and enable
			# them.
			-DVTK_MODULE_ENABLE_VTK_DomainsMicroscopy="DONT_WANT"
			-DVTK_MODULE_ENABLE_VTK_fides="DONT_WANT"
			-DVTK_MODULE_ENABLE_VTK_FiltersOpenTURNS="DONT_WANT"
			-DVTK_MODULE_ENABLE_VTK_IOADIOS2="DONT_WANT"
			-DVTK_MODULE_ENABLE_VTK_IOFides="DONT_WANT"
			-DVTK_MODULE_ENABLE_VTK_IOOpenVDB="DONT_WANT"
			-DVTK_MODULE_ENABLE_VTK_IOPDAL="DONT_WANT"
			-DVTK_MODULE_ENABLE_VTK_RenderingOpenVR="DONT_WANT"

			# available in ::guru, so avoid  detection if installed
			-DVTK_MODULE_USE_EXTERNAL_VTK_cli11=OFF
		)
	fi

	# TODO: consider removing USE flags and enable by default
	if use boost; then
		mycmakeargs+=(
			-DVTK_MODULE_ENABLE_VTK_InfovisBoost="WANT"
			-DVTK_MODULE_ENABLE_VTK_InfovisBoostGraphAlgorithms="WANT"
		)
	fi

	# TODO: checks this on updates of nvidia-cuda-toolkit and update
	# the list of available arches if necessary, i.e. add new arches
	# once they are released at the end of the list before all.
	# See https://en.wikipedia.org/wiki/CUDA#GPUs_supported
	if use cuda; then
		local cuda_arch=
		case ${VTK_CUDA_ARCH:-native} in
			# we ignore fermi arch, because current nvidia-cuda-toolkit-11*
			# no longer supports it
			kepler|maxwell|pascal|volta|turing|ampere|all)
				cuda_arch=${VTK_CUDA_ARCH}
				;;
			native)
				ewarn "If auto detection fails for you, please try and export the"
				ewarn "VTK_CUDA_ARCH environment variable to one of the common arch"
				ewarn "names: kepler, maxwell, pascal, volta, turing, ampere or all."
				cuda_arch=native
				;;
			*)
				eerror "Please properly set the VTK_CUDA_ARCH environment variable to"
				eerror "one of: kepler, maxwell, pascal, volta, turing, ampere, all"
				die "Invalid CUDA architecture given: '${VTK_CUDA_ARCH}'!"
				;;
		esac
		ewarn "Using CUDA architecture '${cuda_arch}'"

		mycmakeargs+=( -DVTKm_CUDA_Architecture=${cuda_arch} )
	fi

	if use debug; then
		mycmakeargs+=(
			-DVTK_DEBUG_LEAKS=ON
			-DVTK_DEBUG_MODULE=ON
			-DVTK_DEBUG_MODLE_ALL=ON
			-DVTK_ENABLE_SANITIZER=ON
			-DVTK_EXTRA_COMPILER_WARNINGS=ON
			-DVTK_WARN_ON_DISPATCH_FAILURE=ON
		)
		if use rendering; then
			mycmakeargs+=( -DVTK_OPENGL_ENABLE_STREAM_ANNOTATIONS=ON )
		fi
	fi

	if use examples || use test; then
		mycmakeargs+=( -DVTK_USE_LARGE_DATA=ON )
	fi

	# TODO: consider removing the USE flag and enable by default
	if use ffmpeg; then
		mycmakeargs+=( -DVTK_MODULE_ENABLE_VTK_IOFFMPEG="WANT" )
	fi

	# TODO: consider removing the USE flag and enable by default
	if use gdal; then
		mycmakeargs+=( -DVTK_MODULE_ENABLE_VTK_GeovisGDAL="WANT" )
	fi

	if ! use java && ! use python; then
		# defaults to ON
		mycmakeargs+=( -DVTK_ENABLE_WRAPPING=OFF )
	fi

	if use java; then
		mycmakeargs+=(
			-DCMAKE_INSTALL_JARDIR="share/${PN}"
			-DVTK_ENABLE_WRAPPING=ON
		)
	fi

	if use mpi; then
		mycmakeargs+=(
			-DVTK_GROUP_ENABLE_MPI="YES"
			-DVTK_MODULE_ENABLE_VTK_IOH5part="WANT"
			-DVTK_MODULE_ENABLE_VTK_IOParallel="WANT"
			-DVTK_MODULE_ENABLE_VTK_IOParallelNetCDF="WANT"
			-DVTK_MODULE_ENABLE_VTK_IOParallelXML="WANT"
			-DVTK_MODULE_ENABLE_VTK_ParallelMPI="WANT"
			-DVTK_MODULE_ENABLE_VTK_RenderingParallel="WANT"
			-DVTK_MODULE_ENABLE_VTK_h5part="WANT"
			-DVTKm_ENABLE_MPI=ON
		)
		if use python; then
			mycmakeargs+=( -DVTK_MODULE_ENABLE_VTK_ParallelMPI4Py="WANT" )
		fi
	fi

	if use mysql; then
		mycmakeargs+=(
			-DVTK_MODULE_ENABLE_VTK_IOMySQL="WANT"
			-DVTK_MODULE_ENABLE_VTK_IOSQL="WANT"
		)
	fi

	if use odbc; then
		mycmakeargs+=( -DVTK_MODULE_ENABLE_VTK_IOODBC="WANT" )
	fi

	if use postgres; then
		mycmakeargs+=(
			-DVTK_MODULE_ENABLE_VTK_IOPostgreSQL="WANT"
			-DVTK_MODULE_ENABLE_VTK_IOSQL="WANT"
		)
	fi

	if use python; then
		mycmakeargs+=(
			-DVTK_ENABLE_WRAPPING=ON
			-DPython3_EXECUTABLE="${PYTHON}"
			-DVTK_PYTHON_SITE_PACKAGES_SUFFIX="lib/${EPYTHON}/site-packages"
		)
	fi

	if use qt5; then
		mycmakeargs+=(
			-DVTK_MODULE_ENABLE_VTK_GUISupportQt="WANT"
			-DVTK_QT_VERSION="5"
		)
		if use mysql || use postgres; then
			mycmakeargs+=( -DVTK_MODULE_ENABLE_VTK_GUISupportQtSQL="WANT" )
		fi
		if use rendering; then
			mycmakeargs+=( -DVTK_MODULE_ENABLE_VTK_RenderingQt="WANT" )
		fi
		if use views; then
			mycmakeargs+=( -DVTK_MODULE_ENABLE_VTK_ViewsQt="WANT" )
		fi
	fi

	if use rendering || use test || use web || use all-modules; then
		# needs patched version
		mycmakeargs+=( -DVTK_MODULE_USE_EXTERNAL_VTK_libharu=OFF )
	fi

	if use rendering; then
		mycmakeargs+=( -DVTK_MODULE_ENABLE_VTK_IOExportGL2PS="WANT" )
	fi

	if use test; then
		ewarn "Testing requires VTK_FORBID_DOWNLOADS=OFF by upstream."
		ewarn "Care has been taken to pre-download all required files."
		ewarn "In case you find missing files, please inform me."
		mycmakeargs+=(
			-DVTK_BUILD_TESTING=ON
			-DVTK_FORBID_DOWNLOADS=OFF

			-DVTK_MODULE_ENABLE_VTK_octree="WANT"
			-DVTK_MODULE_ENABLE_VTK_ViewsCore="WANT"

			# available in ::guru, so avoid  detection if installed
			-DVTK_MODULE_USE_EXTERNAL_VTK_cli11=OFF
		)
	else
		mycmakeargs+=(
			-DVTK_BUILD_TESTING=OFF
			-DVTK_FORBID_DOWNLOADS=ON
		)
	fi

	# FIXME: upstream provides 4 threading models, as of 9.1.0. These are
	# sequential, stdthread, openmp and tbb. AFAICS all of them can be
	# enabled at the same time. Sequential and Stdthread are enabled by
	# default. The default selected type for the build is sequential.
	# Assuming sequential < stdpthread < openmp < tbb wrt speed, although
	# this is dependent on the actual scenario where threading is used.
	if use tbb; then
		mycmakeargs+=( -DVTK_SMP_IMPLEMENTATION_TYPE="TBB" )
	elif use openmp; then
		mycmakeargs+=( -DVTK_SMP_IMPLEMENTATION_TYPE="OpenMP" )
	elif use threads; then
		mycmakeargs+=( -DVTK_SMP_IMPLEMENTATION_TYPE="STDThread" )
	else
		mycmakeargs+=( -DVTK_SMP_IMPLEMENTATION_TYPE="Sequential" )
	fi

	use java && export JAVA_HOME="${EPREFIX}/etc/java-config-2/current-system-vm"

	if use mpi; then
		export CC=mpicc
		export CXX=mpicxx
		export FC=mpif90
		export F90=mpif90
		export F77=mpif77
	fi

	cmake_src_configure
}

# FIXME: avoid nonfatal?
# see https://github.com/gentoo/gentoo/pull/22878#discussion_r747204043
src_test() {
#	nonfatal virtx cmake_src_test
	virtx cmake_src_test
}

src_install() {
	use web && webapp_src_preinst

	# Stop web page images from being compressed
	if use doc; then
		HTML_DOCS=( "${WORKDIR}/html/." )
	fi

	cmake_src_install

	use java && java-pkg_regjar "${ED}"/usr/share/${PN}/${PN}.jar

	# install examples
	if use examples; then
		einfo "Installing examples"
		mv -v {E,e}xamples || die
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples

		einfo "Installing datafiles"
		insinto /usr/share/${PN}/data
		doins -r "${S}/.ExternalData"
	fi

	# with MPI runpath's are not deleted properly
	if use mpi; then
		chrpath -d "${ED}"/usr/$(get_libdir)/*.so.${PV} || die
	fi

	use python && python_optimize

	# environment
#	cat >> "${T}"/40${PN} <<- EOF || die
#		VTK_DATA_ROOT=${EPREFIX}/usr/share/${PN}/data
#		VTK_DIR=${EPREFIX}/usr/$(get_libdir)/${PN}
#		VTKHOME=${EPREFIX}/usr
#		EOF
#	doenvd "${T}"/40${PN}

	use web && webapp_src_install

	# Temporary!
	# Avoid collision with paraview.
	# bug #793221
	rm -rf "${ED}"/usr/share/vtkm-1.5/VTKm{LICENSE.txt,README.md} || die
}

# webapp.eclass exports these but we want it optional #534036
pkg_postinst() {
	use web && webapp_pkg_postinst

	if use examples; then
		einfo "You can get more and updated examples at"
		einfo "https://kitware.github.io/vtk-examples/site/"
	fi
}

pkg_prerm() {
	use web && webapp_pkg_prerm
}
