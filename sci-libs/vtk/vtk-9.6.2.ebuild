# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO:
# - add USE flag for remote modules? Those modules can be downloaded properly before building.
# - vtkm was renamed to viskores. Rename once usemove is implemented.

PYTHON_COMPAT=( python3_{12..14} )
PYTHON_REQ_USE="tk?"

WEBAPP_OPTIONAL=yes
WEBAPP_MANUAL_SLOT=yes

inherit check-reqs cmake cuda java-pkg-opt-2 multiprocessing python-single-r1 toolchain-funcs virtualx webapp
inherit flag-o-matic xdg-utils

# Short package version
MY_PV="$(ver_cut 1-2)"

DESCRIPTION="The Visualization Toolkit"
HOMEPAGE="https://www.vtk.org/"

if [[ ${PV} = *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="
		https://github.com/Kitware/VTK.git
		https://gitlab.kitware.com/vtk/vtk.git
	"
else
	SRC_URI="
		https://www.vtk.org/files/release/${MY_PV}/VTK-${PV}.tar.gz
		cuda? ( vtkm? (
			https://github.com/Viskores/viskores/commit/92cbfd81199208f79d1644469c1514fe91ba0e2e.patch
				-> ${PN}-9.6.2-viscores-PR290.patch
			https://github.com/Viskores/viskores/commit/0bb528866ae2263a7f37aee23b63f275d4bcaf40.patch
				-> ${PN}-9.6.2-viscores-PR314.patch
			https://github.com/Viskores/viskores/commit/7ca23d4e594864b816b3335ddf0c741e0988d84e.patch
				-> ${PN}-9.6.2-viscores-PR336.patch
		) )
		doc? (
			https://www.vtk.org/files/release/${MY_PV}/vtkDocHtml-${PV}.tar.gz
		)
		examples? (
			https://www.vtk.org/files/release/${MY_PV}/VTKLargeData-${PV}.tar.gz
			https://www.vtk.org/files/release/${MY_PV}/VTKLargeDataFiles-${PV}.tar.gz
		)
		gdal? (
			https://gitlab.kitware.com/vtk/vtk/-/commit/2395603fdddc40c29efc64c632ae98225ca2a58e.patch
				-> ${PN}-9.6.2-PR13291.patch
		)
		test? (
			https://www.vtk.org/files/release/${MY_PV}/VTKData-${PV}.tar.gz
			https://www.vtk.org/files/release/${MY_PV}/VTKDataFiles-${PV}.tar.gz
			https://www.vtk.org/files/release/${MY_PV}/VTKLargeData-${PV}.tar.gz
			https://www.vtk.org/files/release/${MY_PV}/VTKLargeDataFiles-${PV}.tar.gz
			python? (
				https://gitlab.kitware.com/vtk/vtk/-/commit/8f1eef77be1accab6c536f53a03439b0d732eb84.patch
				-> ${PN}-9.6.2-PR13147.patch
			)
		)
	"
	S="${WORKDIR}/VTK-${PV}"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="BSD LGPL-2"
SLOT="0/${MY_PV}"

# TODO: Like to simplify these. Mostly the flags related to Groups.
IUSE="
	all-modules boost +cgns cuda debug doc egl examples ffmpeg gdal gles2 imaging
	java +logging minimal mpi mysql +netcdf odbc opencascade openmp openvdb pdal postgres
	python qt6 +rendering tbb test +threads tk +truetype video_cards_nvidia +views vtkm web
	+video_cards_zink
"

RESTRICT="!test? ( test )"

# we can't test egl or gles2 without hardware access
REQUIRED_USE="
	all-modules? (
		boost cgns ffmpeg gdal imaging mysql netcdf odbc opencascade openvdb pdal
		postgres rendering truetype views
	)
	cuda? ( video_cards_nvidia vtkm )
	java? ( rendering )
	minimal? ( !gdal !rendering )
	!minimal? ( cgns netcdf rendering )
	python? ( ${PYTHON_REQUIRED_USE} )
	qt6? ( rendering )
	tk? ( python rendering )
	web? ( python )
	rendering? ( truetype views )
	test? ( !egl !gles2 )
"

# eigen, nlohmann_json, pegtl and utfcpp are referenced in the cmake files
# and need to be available when VTK consumers configure the dependencies.
# opencascade does things with gles2/opengl detection so we need to align both
RDEPEND="
	app-arch/lz4:=
	app-arch/xz-utils
	dev-cpp/eigen:=
	dev-cpp/nlohmann_json
	dev-db/sqlite:3
	dev-libs/expat
	dev-libs/jsoncpp:=
	>=dev-libs/libfmt-8.1.1:=
	dev-libs/libxml2:2=
	>=dev-libs/pegtl-3
	dev-libs/pugixml
	dev-libs/utfcpp
	media-libs/freetype
	media-libs/libjpeg-turbo:=
	media-libs/libogg
	media-libs/libpng:=
	media-libs/tiff:=
	sci-libs/hdf5:=[mpi=]
	virtual/zlib:=
	virtual/opengl[X]
	boost? ( dev-libs/boost:=[mpi?] )
	cgns? (
		>=sci-libs/cgnslib-4.1.1:=[hdf5,mpi=]
	)
	cuda? ( dev-util/nvidia-cuda-toolkit:= )
	ffmpeg? ( media-video/ffmpeg:= )
	gdal? ( sci-libs/gdal:= )
	java? ( >=virtual/jdk-11:= )
	!minimal? (
		>=media-libs/libharu-2.4.0:=
		media-libs/libtheora:=
		sci-libs/proj:=
	)
	mpi? ( virtual/mpi[romio] )
	mysql? ( dev-db/mariadb-connector-c:= )
	netcdf? ( sci-libs/netcdf:=[mpi=] )
	odbc? ( dev-db/unixODBC )
	openvdb? ( media-gfx/openvdb:= )
	opencascade? ( <sci-libs/opencascade-8:=[gles2=] )
	pdal? ( sci-libs/pdal:= )
	postgres? ( dev-db/postgresql:= )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/cftime[${PYTHON_USEDEP}]
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-python/xarray[${PYTHON_USEDEP}]
			mpi? ( dev-python/mpi4py[${PYTHON_USEDEP}] )
			rendering? ( dev-python/matplotlib[${PYTHON_USEDEP}] )
		')
	)
	qt6? (
		dev-qt/qtbase:6[gui,opengl,sql,widgets]
		dev-qt/qtdeclarative:6[opengl]
		dev-qt/qtshadertools:6
		x11-libs/libxkbcommon
		!gles2? (
			dev-qt/qtbase:6[-gles2-only]
		)
	)
	rendering? (
		media-libs/libglvnd[X]
		x11-libs/gl2ps
		x11-libs/libXcursor
		x11-libs/libX11
	)
	tbb? ( dev-cpp/tbb:= )
	tk? ( dev-lang/tk:= )
	truetype? ( media-libs/fontconfig )
	video_cards_nvidia? ( x11-drivers/nvidia-drivers )
	views? (
		x11-libs/libX11
	)
	vtkm? (
		sci-libs/hdf5[cxx]
		mpi? (
			sci-libs/hdf5[unsupported]
		)
	)
	web? ( ${WEBAPP_DEPEND} )
"

# we need OpenGL 3.2 or later -> llvmpipe -> mesa[llvm]
DEPEND="
	${RDEPEND}
	dev-cpp/cli11
	test? (
		media-libs/glew
		media-libs/mesa[llvm,video_cards_zink?]
		x11-libs/libXcursor
		rendering? ( media-libs/freeglut )
	)
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-9.2.5-pegtl-3.x.patch"
	"${FILESDIR}/${PN}-9.3.0-java.patch"

	"${FILESDIR}/${PN}-9.4.2-pegtl-3.x.patch"
	"${FILESDIR}/${PN}-9.5.2-gcc17-include-string.patch"

	# "${DISTDIR}/${PN}-9.6.2-viscores-PR290.patch"
	# "${DISTDIR}/${PN}-9.6.2-viscores-PR314.patch"
	# "${DISTDIR}/${PN}-9.6.2-viscores-PR336.patch"
	# "${FILESDIR}/${PN}-9.6.2-cccl-3.0.patch"
)

DOCS=( CONTRIBUTING.md README.md )

vtk_check_reqs() {
	local dsk="$((
		1024
		+ $(usex cuda 8192 0)
		+ $(usex doc 3072 0)
		+ $(usex examples 2048 0)
		+ $(usex test 0 0)
	))"
# cuda 5.4 G + 1.4G
# cuda 4.7 G + 1.5G
	local -x CHECKREQS_DISK_BUILD=${dsk}M

	# In case users are not aware of the extra NINJAOPTS, check
	# for the more common MAKEOPTS, in case NINJAOPTS is empty
	local jobs=1
	if [[ -n "${NINJAOPTS}" ]]; then
		jobs=$(makeopts_jobs "${NINJAOPTS}" "$(get_nproc)")
	elif [[ -n "${MAKEOPTS}" ]]; then
		jobs=$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")
	fi

	if use cuda; then
		local mem="$((
			$(usex cuda $(( 7 * 1024 )) 0) * $(( jobs > 4 ? 4 : jobs ))
		))"
		local CHECKREQS_MEMORY=${mem}M
	fi

	"check-reqs_pkg_${EBUILD_PHASE}"
}

cuda_get_host_compiler() {
	if [[ -n "${NVCC_CCBIN}" ]]; then
		echo "${NVCC_CCBIN}"
		return
	fi

	if [[ -n "${CUDAHOSTCXX}" ]]; then
		echo "${CUDAHOSTCXX}"
		return
	fi

	einfo "Trying to find working CUDA host compiler"

	if ! tc-is-gcc && ! tc-is-clang; then
		die "$(tc-get-compiler-type) compiler is not supported"
	fi

	local compiler compiler_type compiler_version
	local package package_version
	local NVCC_CCBIN_default

	compiler_type="$(tc-get-compiler-type)"
	compiler_version="$("${compiler_type}-major-version")"

	# try the default compiler first
	NVCC_CCBIN="$(tc-getCXX)"
	NVCC_CCBIN_default="${NVCC_CCBIN}-${compiler_version}"

	compiler="${NVCC_CCBIN/%-${compiler_version}}"

	# store the package so we can re-use it later
	package="sys-devel/${compiler_type}"
	package_version="${package}"

	ebegin "testing ${NVCC_CCBIN_default} (default)"

	while ! nvcc -v -ccbin "${NVCC_CCBIN}" - -x cu <<<"int main(){}" &>> "${T}/cuda_get_host_compiler.log" ; do
		eend 1

		while true; do
			# prepare next version
			if ! package_version="<$(best_version "${package_version}")"; then
				die "could not find a supported version of ${compiler}"
			fi

			NVCC_CCBIN="${compiler}-$(ver_cut 1 "${package_version/#<${package}-/}")"

			[[ "${NVCC_CCBIN}" != "${NVCC_CCBIN_default}" ]] && break
		done
		ebegin "testing ${NVCC_CCBIN}"
	done
	eend $?

	# clean temp file
	rm -f a.out

	echo "${NVCC_CCBIN}"
	export NVCC_CCBIN
}

cuda_get_host_native_arch() {
	[[ -n ${CUDAARCHS} ]] && echo "${CUDAARCHS}"

	__nvcc_device_query || die "failed to query the native device"
}

vtk_add_sandbox() {
	local WRITE=()

	# mesa via virtx will make use of udmabuf if it exists
	[[ -c "/dev/udmabuf" ]] && WRITE+=( "/dev/udmabuf" )

	readarray -t dris <<<"$(
		find /sys/class/drm/*/device/drm \
			-mindepth 1 -maxdepth 1 -type d -exec basename {} \; \
			| sort | uniq | sed 's:^:/dev/dri/:'
	)"

	[[ -n "${dris[*]}" ]] && WRITE+=( "${dris[@]}" )

	if [[ -d /sys/module/nvidia ]]; then
		# /dev/nvidia{0-9}
		readarray -t nvidia_devs <<<"$(
			find /dev -regextype posix-extended  -regex '/dev/nvidia(|-(nvswitch|vgpu))[0-9]*'
		)"

		[[ -n "${nvidia_devs[*]}" ]] && WRITE+=( "${nvidia_devs[@]}" )

		WRITE+=(
			"/dev/nvidiactl"
			"/dev/nvidia-modeset"

			"/dev/nvidia-uvm"
			"/dev/nvidia-uvm-tools"

			"/dev/nvidia-caps/"
		)

		addpredict "/dev/char/"
	fi

	# for portage
	WRITE+=(
		"/proc/self/task/"
	)

	local dev
	for dev in "${WRITE[@]}"; do
		if [[ ! -e "${dev}" ]]; then
			eqawarn "${dev} does not exist"
			# continue
		fi

		if [[ -w "${dev}" ]]; then
			eqawarn "${dev} is already writable"
			# continue
		fi

		eqawarn "addwrite ${dev}"
		addwrite "${dev}"

		if [[ ! -d "${dev}" ]] && [[ ! -w "${dev}" ]]; then
			eerror "can not access ${dev} after addwrite"
		fi
	done
}

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp

	vtk_check_reqs

	# When building binpkgs you probably want to include all targets
	if use cuda && [[ ${MERGE_TYPE} == "buildonly" ]] && [[ -n "${CUDAARCHS}" ]]; then
		local info_message="When building a binary package it's recommended to unset CUDAARCHS"
		einfo "$info_message so all available architectures are build."
	fi
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp

	vtk_check_reqs

	if use cuda && [[ ! -e /dev/nvidia-uvm ]]; then
		# NOTE We try to load nvidia-uvm and nvidia-modeset here,
		# so __nvcc_device_query does not fail later.

		nvidia-smi -L || true

		if has_version ">=dev-util/nvidia-cuda-toolkit-12.6.0"; then
			# NOTE Without this ptxas will consume large amounts of memory.
			# The user can override this using NVCC_APPREND_FLAGS.
			# #973279
			# TODO Should go into the eclass.
			export NVCC_PREPREND_FLAGS="${NVCC_PREPREND_FLAGS:+"${NVCC_PREPREND_FLAGS} "} -Ofc min --threads $(makeopts_jobs)"
			einfo "Using NVCC_PREPREND_FLAGS=\"${NVCC_PREPREND_FLAGS}\""
			einfo "You can override this using NVCC_APPREND_FLAGS"
		fi
	fi

	use java && java-pkg-opt-2_pkg_setup
	use python && python-single-r1_pkg_setup
	use web && webapp_pkg_setup
}

# Note: The following libraries are marked as internal by kitware
#	and can currently not unbundled:
#	diy2, exodusII, fides, h5part, kissfft, loguru, verdict, vpic,
#	viskores, xdmf{2,3}, zfp
# TODO: exprtk, ioss
# Note: As of v9.2.2 we no longer drop bundled libraries, when using system
# libraries. This just saves a little space. CMake logic of VTK on ThirdParty
# libraries avoids automagic builds, so deletion is not needed to catch these.
src_prepare() {
	if use doc; then
		einfo "Removing .md5 files from documents."
		rm -f "${WORKDIR}"/html/*.md5 || die "Failed to remove superfluous hashes"
		sed -e "s|\${VTK_BINARY_DIR}/Utilities/Doxygen/doc|${WORKDIR}|" \
			-i Utilities/Doxygen/CMakeLists.txt || die
	fi

	if use cuda && use vtkm; then
		pushd ThirdParty/viskores/vtkviskores/viskores >/dev/null || die
		eapply "${DISTDIR}/${PN}-9.6.2-viscores-PR290.patch"
		eapply "${DISTDIR}/${PN}-9.6.2-viscores-PR314.patch"
		eapply "${DISTDIR}/${PN}-9.6.2-viscores-PR336.patch"
		popd >/dev/null || die
		eapply "${FILESDIR}/${PN}-9.6.2-cccl-3.0.patch"
	fi

	if use gdal; then
		eapply "${DISTDIR}/${PN}-9.6.2-PR13291.patch"
	fi

	if use python && use test; then
		eapply "${DISTDIR}/${PN}-9.6.2-PR13147.patch"
	fi

	cmake_src_prepare

	if use test; then
		ebegin "Copying data files to ${BUILD_DIR}"
		mkdir -p "${BUILD_DIR}/ExternalData" || die
		pushd "${BUILD_DIR}/ExternalData" >/dev/null || die
		ln -sf "../../${S}/.ExternalData/README.rst" . || die
		ln -sf "../../${S}/.ExternalData/SHA512" . || die
		popd >/dev/null || die
		eend "$?"
	fi
}

# TODO: check these and consider to use them
#	VTK_BUILD_SCALED_SOA_ARRAYS
#	VTK_DISPATCH_{AOS,SOA,TYPED}_ARRAYS
src_configure() {
	filter-lto

	if ! is-flagq "$(usex debug '-DDEBUG' '-DNDEBUG')"; then
		append-cxxflags "$(usex debug '-DDEBUG' '-DNDEBUG')"
	fi

	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Git="yes"
		-DVTK_GIT_DESCRIBE="v${PV}"
		-DVTK_VERSION_FULL="${PV}"
		-DGIT_EXECUTABLE="${T}/notgit"

		-DCMAKE_POLICY_DEFAULT_CMP0167="OLD"
		-DCMAKE_POLICY_DEFAULT_CMP0174="OLD"
		-DCMAKE_POLICY_DEFAULT_CMP0177="OLD"

		-DCMAKE_INSTALL_LICENSEDIR="share/${PN}/licenses"
		# c++17 since 9.5.0
		-DVTK_IGNORE_CMAKE_CXX17_CHECKS="no"

		# -DCMAKE_UNITY_BUILD=ON
		# -DCMAKE_UNITY_BUILD_BATCH_SIZE=16

		-DVTK_ANDROID_BUILD=OFF
		-DVTK_IOS_BUILD=OFF

		-DVTK_BUILD_ALL_MODULES="$(usex all-modules)"
		# we use the pre-built documentation and install these with USE=doc
		-DVTK_BUILD_DOCUMENTATION=OFF
		-DVTK_BUILD_EXAMPLES="$(usex examples)"

		# no package in the tree: https://github.com/LLNL/conduit
		-DVTK_ENABLE_CATALYST=OFF
		-DVTK_ENABLE_KITS=OFF
		-DVTK_ENABLE_LOGGING="$(usex logging)"
		# defaults to ON: USE flag for this?
		-DVTK_ENABLE_REMOTE_MODULES=OFF

		# disable fetching files during build
		-DVTK_FORBID_DOWNLOADS="yes"

		-DVTK_GROUP_ENABLE_Imaging="$(usex imaging "YES" "NO")"
		-DVTK_GROUP_ENABLE_MPI="$(usex mpi "YES" "NO")"
		-DVTK_GROUP_ENABLE_Qt="$(usex qt6 "YES" "NO")"
		-DVTK_GROUP_ENABLE_Rendering="$(usex rendering "YES" "NO")"
		-DVTK_GROUP_ENABLE_StandAlone="$(usex minimal "NO" "YES")"
		-DVTK_GROUP_ENABLE_Views="$(usex views "YES" "NO")"
		-DVTK_GROUP_ENABLE_Web="$(usex web "YES" "NO")"

		-DVTK_INSTALL_SDK=ON

		-DVTK_MODULE_ENABLE_VTK_IOCGNSReader="$(usex cgns "YES" "NO")"
		-DVTK_MODULE_ENABLE_VTK_IOExportPDF="$(usex minimal "NO" "YES")"
		-DVTK_MODULE_ENABLE_VTK_IOLAS="NO" # las is dead
		-DVTK_MODULE_ENABLE_VTK_IONetCDF="$(usex netcdf "YES" "NO")"
		-DVTK_MODULE_ENABLE_VTK_IOOCCT="$(usex opencascade "YES" "NO")"
		-DVTK_MODULE_ENABLE_VTK_IOOggTheora="$(usex minimal "NO" "YES")"
		-DVTK_MODULE_ENABLE_VTK_IOOpenVDB="$(usex openvdb "YES" "NO")"
		-DVTK_MODULE_ENABLE_VTK_IOSQL="YES" # sqlite
		-DVTK_MODULE_ENABLE_VTK_IOPDAL="$(usex pdal "YES" "NO")"
		-DVTK_MODULE_ENABLE_VTK_IOXML="YES"
		-DVTK_MODULE_ENABLE_VTK_IOXMLParser="YES"
		-DVTK_MODULE_ENABLE_VTK_RenderingFreeType="$(usex truetype "YES" "NO")"
		-DVTK_MODULE_ENABLE_VTK_RenderingFreeTypeFontConfig="$(usex truetype "YES" "NO")"
		-DVTK_MODULE_ENABLE_VTK_cgns="$(usex cgns "YES" "NO")"
		# -DVTK_MODULE_ENABLE_VTK_cli11
		# -DVTK_MODULE_ENABLE_VTK_dy2
		-DVTK_MODULE_ENABLE_VTK_eigen="YES"
		# -DVTK_MODULE_ENABLE_VTK_exodusII
		-DVTK_MODULE_ENABLE_VTK_expat="YES"
		# -DVTK_MODULE_ENABLE_VTK_exprtk
		# -DVTK_MODULE_ENABLE_VTK_fast_float
		# -DVTK_MODULE_ENABLE_VTK_fides
		-DVTK_MODULE_ENABLE_VTK_fmt="YES"
		-DVTK_MODULE_ENABLE_VTK_freetype="$(usex truetype "YES" "NO")"
		# -DVTK_MODULE_ENABLE_VTK_glad
		# -DVTK_MODULE_ENABLE_VTK_h5part
		-DVTK_MODULE_ENABLE_VTK_hdf5="YES"
		# bug #982169
		-DHDF5_IS_PARALLEL="$(usex mpi "YES" "NO")"
		# -DVTK_MODULE_ENABLE_VTK_ioss
		-DVTK_MODULE_ENABLE_VTK_jpeg="YES"
		-DVTK_MODULE_ENABLE_VTK_jsoncpp="YES"
		# -DVTK_MODULE_ENABLE_VTK_kissfft
		# -DVTK_MODULE_ENABLE_VTK_kwiml
		-DVTK_MODULE_ENABLE_VTK_libharu="$(usex minimal "NO" "YES")"
		-DVTK_MODULE_ENABLE_VTK_libproj="$(usex minimal "NO" "YES")"
		-DVTK_MODULE_ENABLE_VTK_libxml2="YES"
		# -DVTK_MODULE_ENABLE_VTK_loguru
		-DVTK_MODULE_ENABLE_VTK_lz4="YES"
		-DVTK_MODULE_ENABLE_VTK_lzma="YES"
		# -DVTK_MODULE_ENABLE_VTK_metaio
		-DVTK_MODULE_ENABLE_VTK_netcdf="$(usex netcdf "YES" "NO")"
		-DVTK_MODULE_ENABLE_VTK_nlohmannjson="YES"
		# -DVTK_MODULE_ENABLE_VTK_octree
		-DVTK_MODULE_ENABLE_VTK_ogg="YES"
		-DVTK_MODULE_ENABLE_VTK_pegtl="YES"
		-DVTK_MODULE_ENABLE_VTK_png="YES"
		-DVTK_MODULE_ENABLE_VTK_pugixml="YES"
		# -DVTK_MODULE_ENABLE_VTK_scn="$(usex test "YES" "NO")"
		-DVTK_MODULE_ENABLE_VTK_sqlite="YES"
		-DVTK_MODULE_ENABLE_VTK_theora="$(usex minimal "NO" "YES")"
		-DVTK_MODULE_ENABLE_VTK_tiff="YES"
		# -DVTK_MODULE_ENABLE_VTK_token
		-DVTK_MODULE_ENABLE_VTK_utf8="YES"
		# -DVTK_MODULE_ENABLE_VTK_verdict
		# -DVTK_MODULE_ENABLE_VTK_vpic
		# -DVTK_MODULE_ENABLE_VTK_vtksys
		-DVTK_MODULE_ENABLE_VTK_vtkviskores="$(usex vtkm "YES" "NO")"
		# -DVTK_MODULE_ENABLE_VTK_xdmf2
		# -DVTK_MODULE_ENABLE_VTK_xdmf3
		-DVTK_MODULE_ENABLE_VTK_zlib="YES"

		# not packaged in Gentoo
		-DVTK_MODULE_USE_EXTERNAL_VTK_fast_float=OFF
		-DVTK_MODULE_USE_EXTERNAL_VTK_exprtk=OFF
		-DVTK_MODULE_USE_EXTERNAL_VTK_ioss=OFF
		-DVTK_MODULE_USE_EXTERNAL_VTK_token=OFF
		-DVTK_MODULE_USE_EXTERNAL_VTK_verdict=OFF
		-DVTK_MODULE_USE_EXTERNAL_VTK_vtkviskores=OFF

		-DVTK_RELOCATABLE_INSTALL=ON
		-DVTK_UNIFIED_INSTALL_TREE=ON

		-DVTK_SMP_ENABLE_OPENMP="$(usex openmp)"
		-DVTK_SMP_ENABLE_STDTHREAD="$(usex threads)"
		-DVTK_SMP_ENABLE_TBB="$(usex tbb)"

		-DVTK_USE_CUDA="$(usex cuda)"
		-DVTK_USE_KOKKOS="no" # "$(usex hip)" # requires kokkos
		# use system libraries where possible
		-DVTK_USE_EXTERNAL=ON
		# avoid finding package from either ::guru or ::sci
		-DVTK_USE_MEMKIND=OFF
		-DVTK_USE_MPI="$(usex mpi)"
		-DVTK_USE_TK="$(usex tk)"
		-DVTK_USE_X=ON

		-DVTK_WHEEL_BUILD=OFF

		-DVTK_WRAP_JAVA="$(usex java)"
		-DVTK_WRAP_PYTHON="$(usex python)"
	)

	if use all-modules; then
		mycmakeargs+=(
			# no package in ::gentoo
			-DVTK_ENABLE_OSPRAY=OFF
			# TODO: some of these are tied to the VTK_ENABLE_REMOTE_MODULES
			# option. Check whether we can download them clean and enable
			# them.
			-DVTK_MODULE_ENABLE_VTK_DomainsMicroscopy="NO"
			-DVTK_MODULE_ENABLE_VTK_fides="NO"
			-DVTK_MODULE_ENABLE_VTK_FiltersOpenTURNS="NO"
			-DVTK_MODULE_ENABLE_VTK_IOADIOS2="NO"
			-DVTK_MODULE_ENABLE_VTK_IOFides="NO"

			-DVTK_MODULE_ENABLE_VTK_RenderingOpenVR="NO"
			-DVTK_MODULE_ENABLE_VTK_RenderingOpenXR="NO"

			-DVTK_MODULE_USE_EXTERNAL_VTK_cli11="YES"
		)
	fi

	if use boost; then
		mycmakeargs+=(
			-DVTK_MODULE_ENABLE_VTK_InfovisBoost="YES"
			-DVTK_MODULE_ENABLE_VTK_InfovisBoostGraphAlgorithms="YES"
		)
	fi

	if use cuda; then
		cuda_add_sandbox -w
		addpredict "/dev/char"

		if ! test -w /dev/nvidiactl; then
			# eqawarn "Can't access the GPU at /dev/nvidiactl."
			# eqawarn "User $(id -nu) is not in the group \"video\"."
			if [[ -z "${CUDAARCHS}" ]]; then
				# build all targets
				mycmakeargs+=(
					-DCMAKE_CUDA_ARCHITECTURES="all"
				)
			fi
		else
			local -x CUDAARCHS
			: "${CUDAARCHS:="$(cuda_get_host_native_arch)"}"
		fi

		# set NVCC_CCBIN
		local -x CUDAHOSTCXX CUDAHOSTLD
		CUDAHOSTCXX="$(cuda_get_host_compiler)"
		CUDAHOSTLD="$(tc-getCXX)"
		export NVCC_CCBIN="${CUDAHOSTCXX}"

		if tc-is-gcc; then
			# Filter out IMPLICIT_LINK_DIRECTORIES picked up by CMAKE_DETERMINE_COMPILER_ABI(CUDA)
			# See /usr/share/cmake/Help/variable/CMAKE_LANG_IMPLICIT_LINK_DIRECTORIES.rst
			CMAKE_CUDA_IMPLICIT_LINK_DIRECTORIES_EXCLUDE=$(
				"${CUDAHOSTLD}" -E -v - <<<"int main(){}" |& \
				grep LIBRARY_PATH | cut -d '=' -f 2 | cut -d ':' -f 1
			)
		fi
	fi

	if use debug; then
		mycmakeargs+=(
			-DVTK_DEBUG_LEAKS=ON
			-DVTK_DEBUG_MODULE=ON
			-DVTK_DEBUG_MODULE_ALL=ON
			-DVTK_ENABLE_SANITIZER=ON
			-DVTK_EXTRA_COMPILER_WARNINGS=ON
			-DVTK_WARN_ON_DISPATCH_FAILURE=ON
		)
		if use rendering; then
			mycmakeargs+=( -DVTK_OPENGL_ENABLE_STREAM_ANNOTATIONS="YES" )
		fi
	fi

	if use examples || use test; then
		mycmakeargs+=( -DVTK_USE_LARGE_DATA=ON )
	fi

	if use ffmpeg; then
		mycmakeargs+=( -DVTK_MODULE_ENABLE_VTK_IOFFMPEG="YES" )
		if use rendering; then
			mycmakeargs+=( -DVTK_MODULE_ENABLE_VTK_RenderingFFMPEGOpenGL2="YES" )
		fi
	fi

	if use gdal; then
		mycmakeargs+=(
			-DVTK_MODULE_ENABLE_VTK_GeovisGDAL="YES"
			-DVTK_MODULE_ENABLE_VTK_IOGDAL="YES"
			-DVTK_MODULE_ENABLE_VTK_IOGeoJSON="YES"
		)
	fi

	if use imaging; then
		mycmakeargs+=(
			-DVTK_MODULE_ENABLE_VTK_ImagingColor="YES"
			-DVTK_MODULE_ENABLE_VTK_ImagingCore="YES"
			-DVTK_MODULE_ENABLE_VTK_ImagingFourier="YES"
			-DVTK_MODULE_ENABLE_VTK_ImagingGeneral="YES"
			-DVTK_MODULE_ENABLE_VTK_ImagingHybrid="YES"
			-DVTK_MODULE_ENABLE_VTK_ImagingMath="YES"
			-DVTK_MODULE_ENABLE_VTK_ImagingMorphological="YES"
			-DVTK_MODULE_ENABLE_VTK_ImagingOpenGL2="YES"
			-DVTK_MODULE_ENABLE_VTK_ImagingSources="YES"
			-DVTK_MODULE_ENABLE_VTK_ImagingStatistics="YES"
			-DVTK_MODULE_ENABLE_VTK_ImagingStencil="YES"
		)
		use rendering && mycmakeargs+=( -DVTK_MODULE_ENABLE_VTK_RenderingImage="YES" )
	fi

	if ! use java && ! use python; then
		# defaults to ON
		mycmakeargs+=( -DVTK_ENABLE_WRAPPING=OFF )
	fi

	if use java; then
		mycmakeargs+=(
			-DCMAKE_INSTALL_JARDIR="share/${PN}"
			-DVTK_ENABLE_WRAPPING=ON
			-DVTK_MODULE_ENABLE_VTK_Java="YES"
			-DVTK_JAVA_RELEASE_VERSION="$(java-config -g PROVIDES_VERSION)"
		)
	fi

	if use minimal; then
		mycmakeargs+=(
			-DVTK_MODULE_ENABLE_VTK_CommonComputationalGeometry="YES"
			-DVTK_MODULE_ENABLE_VTK_CommonExecutionModel="YES"
			-DVTK_MODULE_ENABLE_VTK_CommonMath="YES"
			-DVTK_MODULE_ENABLE_VTK_CommonMisc="YES"
			-DVTK_MODULE_ENABLE_VTK_CommonSystem="YES"
			-DVTK_MODULE_ENABLE_VTK_CommonTransforms="YES"

			-DVTK_MODULE_ENABLE_VTK_FiltersCellGrid="YES"
			-DVTK_MODULE_ENABLE_VTK_FiltersCore="YES"
			-DVTK_MODULE_ENABLE_VTK_FiltersExtraction="YES"
			-DVTK_MODULE_ENABLE_VTK_FiltersGeneral="YES"
			-DVTK_MODULE_ENABLE_VTK_FiltersGeneric="YES"
			-DVTK_MODULE_ENABLE_VTK_FiltersGeometry="YES"
			-DVTK_MODULE_ENABLE_VTK_FiltersHybrid="NO"
			-DVTK_MODULE_ENABLE_VTK_FiltersHyperTree="YES"
			-DVTK_MODULE_ENABLE_VTK_FiltersReduction="YES"
			-DVTK_MODULE_ENABLE_VTK_FiltersSources="YES"
			-DVTK_MODULE_ENABLE_VTK_FiltersStatistics="YES"
			-DVTK_MODULE_ENABLE_VTK_FiltersVerdict="YES"

			-DVTK_MODULE_ENABLE_VTK_IOCellGrid="YES"
			-DVTK_MODULE_ENABLE_VTK_IOCore="YES"
			-DVTK_MODULE_ENABLE_VTK_IOGeometry="NO"
			-DVTK_MODULE_ENABLE_VTK_IOLegacy="YES"

			-DVTK_MODULE_ENABLE_VTK_ParallelCore="YES"
			-DVTK_MODULE_ENABLE_VTK_ParallelDIY="YES"
		)
	fi

	if use mpi; then
		mycmakeargs+=(
			-DVTK_MODULE_ENABLE_VTK_IOH5part="YES"
			-DVTK_MODULE_ENABLE_VTK_IOMPIParallel="YES"
			-DVTK_MODULE_ENABLE_VTK_IOParallel="YES"
			-DVTK_MODULE_ENABLE_VTK_IOParallelNetCDF="$(usex netcdf "YES" "NO")"
			-DVTK_MODULE_ENABLE_VTK_IOParallelXML="YES"
			-DVTK_MODULE_ENABLE_VTK_ParallelMPI="YES"
			-DVTK_MODULE_ENABLE_VTK_h5part="YES"
			-DVTK_MODULE_USE_EXTERNAL_VTK_verdict=OFF
		)
		use imaging && mycmakeargs+=( -DVTK_MODULE_ENABLE_VTK_IOMPIImage="YES" )
		use python && mycmakeargs+=( -DVTK_MODULE_ENABLE_VTK_ParallelMPI4Py="YES" )
		if use rendering; then
			mycmakeargs+=(
				-DVTK_MODULE_ENABLE_VTK_RenderingParallel="YES"
				-DVTK_MODULE_ENABLE_VTK_RenderingParallelLIC="YES"
			)
		fi
		use vtkm && mycmakeargs+=( -DVTKm_ENABLE_MPI=ON )
	fi

	use mysql && mycmakeargs+=( -DVTK_MODULE_ENABLE_VTK_IOMySQL="YES" )
	use odbc && mycmakeargs+=( -DVTK_MODULE_ENABLE_VTK_IOODBC="YES" )
	use openvdb && mycmakeargs+=( -DOpenVDB_CMAKE_PATH="${ESYSROOT}/usr/$(get_libdir)/cmake/OpenVDB" )
	use postgres && mycmakeargs+=( -DVTK_MODULE_ENABLE_VTK_IOPostgreSQL="YES" )

	if use python; then
		mycmakeargs+=(
			-DPython3_EXECUTABLE="${PYTHON}"
			-DVTK_ENABLE_WRAPPING=ON
			-DVTK_MODULE_ENABLE_VTK_Python="YES"
			-DVTK_MODULE_ENABLE_VTK_PythonInterpreter="YES"
			-DVTK_MODULE_ENABLE_VTK_WrappingPythonCore="YES"
			-DVTK_PYTHON_OPTIONAL_LINK="OFF"
			-DVTK_PYTHON_SITE_PACKAGES_SUFFIX="lib/${EPYTHON}/site-packages"
		)
		use rendering && mycmakeargs+=( -DVTK_MODULE_ENABLE_VTK_PythonContext2D="YES" )
	fi

	if use qt6; then
		mycmakeargs+=(
			-DCMAKE_INSTALL_QMLDIR="${EPFREIX}/usr/$(get_libdir)/qt6/qml"
			-DVTK_QT_VERSION="6"
			-DVTK_MODULE_ENABLE_VTK_GUISupportQt="YES"
			-DVTK_MODULE_ENABLE_VTK_GUISupportQtQuick="YES"
		)

		if use mysql || use postgres; then
			mycmakeargs+=( -DVTK_MODULE_ENABLE_VTK_GUISupportQtSQL="YES" )
		fi
		if use rendering; then
			mycmakeargs+=( -DVTK_MODULE_ENABLE_VTK_RenderingQt="YES" )
		fi
		if use views; then
			mycmakeargs+=( -DVTK_MODULE_ENABLE_VTK_ViewsQt="YES" )
		fi
	fi

	if use rendering; then
		mycmakeargs+=(
			# Force using EGL
			-DVTK_OPENGL_HAS_EGL="$(usex egl)"
			-DVTK_OPENGL_USE_GLES="$(usex gles2)"

			-DVTK_ENABLE_OSPRAY=OFF

			-DVTK_MODULE_ENABLE_VTK_IOExportGL2PS="YES"
			-DVTK_MODULE_ENABLE_VTK_RenderingAnari="NO"  # no package in ::gentoo
			-DVTK_MODULE_ENABLE_VTK_RenderingAnnotation="YES"
			-DVTK_MODULE_ENABLE_VTK_RenderingContext2D="YES"
			-DVTK_MODULE_ENABLE_VTK_RenderingContextOpenGL2="YES"
			-DVTK_MODULE_ENABLE_VTK_RenderingCore="YES"
			-DVTK_MODULE_ENABLE_VTK_RenderingExternal="YES"
			-DVTK_MODULE_ENABLE_VTK_RenderingGL2PSOpenGL2="YES"
			-DVTK_MODULE_ENABLE_VTK_RenderingHyperTreeGrid="YES"
			-DVTK_MODULE_ENABLE_VTK_RenderingLICOpenGL2="YES"
			-DVTK_MODULE_ENABLE_VTK_RenderingLOD="YES"
			-DVTK_MODULE_ENABLE_VTK_RenderingLabel="YES"
			-DVTK_MODULE_ENABLE_VTK_RenderingOpenGL2="YES"
			-DVTK_MODULE_ENABLE_VTK_RenderingRayTracing="YES"
			-DVTK_MODULE_ENABLE_VTK_RenderingSceneGraph="YES"
			-DVTK_MODULE_ENABLE_VTK_RenderingUI="YES"
			-DVTK_MODULE_ENABLE_VTK_RenderingVolume="YES"
			-DVTK_MODULE_ENABLE_VTK_RenderingVolumeAMR="YES"
			-DVTK_MODULE_ENABLE_VTK_RenderingVolumeOpenGL2="YES"
			-DVTK_MODULE_ENABLE_VTK_gl2ps="YES"
		)

		use python && mycmakeargs+=( -DVTK_MODULE_ENABLE_VTK_RenderingMatplotlib="YES" )
		use tk && mycmakeargs+=( -DVTK_MODULE_ENABLE_VTK_RenderingTk="YES" )
		use views && mycmakeargs+=( -DVTK_MODULE_ENABLE_VTK_ViewsContext2D="YES" )
		use web && mycmakeargs+=( -DVTK_MODULE_ENABLE_VTK_RenderingVtkJS="YES" )
	fi

	# Testing has been changed in 9.2.5: it is now allowed without
	# requiring to download, if the data files are available locally!
	if use test; then
		mycmakeargs+=(
			-DVTK_BUILD_TESTING=ON
			# disable fetching data files for the default 'all' target
			-DVTK_DATA_EXCLUDE_FROM_ALL=OFF

			# requested even if all use flags are off
			-DVTK_MODULE_ENABLE_VTK_octree="YES"
			-DVTK_MODULE_ENABLE_VTK_ViewsCore="YES"

			-DVTK_MODULE_USE_EXTERNAL_VTK_cli11="YES"
			# not packaged in Gentoo
			-DVTK_MODULE_USE_EXTERNAL_VTK_scn=OFF
		)
	else
		mycmakeargs+=(
			-DVTK_BUILD_TESTING=OFF
			# not packaged in Gentoo
			-DVTK_MODULE_USE_EXTERNAL_VTK_scn=OFF
		)
	fi

	# FIXME: upstream provides 4 threading models, as of 9.1.0. These are
	# sequential, stdthread, openmp and tbb. AFAICS all of them can be
	# enabled at the same time. Sequential and STDThread are enabled by
	# default. The default selected type for the build is sequential.
	# Assuming sequential < STDThread < openmp < tbb wrt speed, although
	# this is dependent on the actual scenario where threading is used.
	if use tbb; then
		mycmakeargs+=( -DVTK_SMP_IMPLEMENTATION_TYPE="TBB" )
	elif use openmp; then # FIXME doesn't work with clang
		mycmakeargs+=( -DVTK_SMP_IMPLEMENTATION_TYPE="OpenMP" )
	elif use threads; then
		mycmakeargs+=( -DVTK_SMP_IMPLEMENTATION_TYPE="STDThread" )
	else
		mycmakeargs+=( -DVTK_SMP_IMPLEMENTATION_TYPE="Sequential" )
	fi

	if use tk; then
		mycmakeargs+=(
			-DVTK_GROUP_ENABLE_Tk="YES"
		)
	fi

	if use views; then
		mycmakeargs+=(
			-DVTK_MODULE_ENABLE_VTK_ViewsCore="YES"
			-DVTK_MODULE_ENABLE_VTK_ViewsInfovis="YES"
		)
	fi

	if use vtkm; then
		mycmakeargs+=(
			-DVTK_MODULE_ENABLE_VTK_AcceleratorsVTKmCore="YES"
			-DVTK_MODULE_ENABLE_VTK_AcceleratorsVTKmDataModel="YES"
			-DVTK_MODULE_ENABLE_VTK_AcceleratorsVTKmFilters="YES"
			-DViskores_ENABLE_CPACK="no" # "Enable CPack packaging of Viskores" ON
			-DViskores_ENABLE_CUDA="$(usex cuda)" # "Enable Cuda support" OFF
			-DViskores_ENABLE_DOCUMENTATION="$(usex doc)" # "Build Doxygen documentation" OFF
			-DViskores_ENABLE_EXAMPLES="$(usex examples)" # "Build examples" OFF
			-DViskores_ENABLE_HDF5_IO="yes" # "Enable HDF5 support" OFF
			-DViskores_HDF5_IS_PARALLEL="$(usex mpi)"
			-DViskores_ENABLE_LOGGING="$(usex logging)" # "Enable Viskores Logging" ON
			-DViskores_ENABLE_MPI="$(usex mpi)" # "Enable MPI support" OFF
			-DViskores_ENABLE_OPENMP="$(usex openmp)" # "Enable OpenMP support" OFF
			-DViskores_ENABLE_RENDERING="$(usex rendering)" # "Enable rendering library" ON
			-DViskores_ENABLE_TBB="$(usex tbb)" # "Enable TBB support" OFF
			-DViskores_ENABLE_TESTING="$(usex test)" # "Enable Viskores Testing" ON
			-DViskores_ENABLE_TUTORIALS="no" # "Build tutorials" OFF
			-DViskores_NO_ASSERT_CUDA="yes" # "Disable assertions for CUDA devices." ON
			-DViskores_NO_ASSERT_HIP="yes" # "Disable assertions for HIP devices." ON
			-DViskores_NO_ASSERT="no" # "Disable assertions in debugging builds." OFF
			-DViskores_NO_INSTALL_README_LICENSE="ON" # bug #793221 # "disable the installation of README and LICENSE files" OFF
			-DViskores_SKIP_LIBRARY_VERSIONS="no" # "Skip versioning VTK-m libraries" OFF
			-DViskores_Vectorization="none" # only sets compiler flags
		)
	fi

	if use web; then
		mycmakeargs+=(
			-DVTK_MODULE_ENABLE_VTK_WebCore="YES"
			-DVTK_MODULE_ENABLE_VTK_WebGLExporter="YES"
		)
		use python && mycmakeargs+=( -DVTK_MODULE_ENABLE_VTK_WebPython="YES" )
	fi

	cmake_src_configure
}

src_compile() {
	use test && cmake_build VTKData
	cmake_src_compile
}

src_test() {
	vtk_add_sandbox

	addwrite /dev/fuse

	# The build system prepends /usr/$(get_libdir) to the RUNPATH instead of appending.
	# Set LD_LIBRARY_PATH to use the just build libraries.
	local -x LD_LIBRARY_PATH="${BUILD_DIR}/$(get_libdir)${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

	# local -x VTK_SMP_BACKEND_IN_USE="STDThread"

	# see VTK_SMP_IMPLEMENTATION_TYPE
	if use tbb; then
		local -x VTK_SMP_BACKEND_IN_USE="TBB"
	# # FIXME Times out under openmp
	# elif use openmp; then
	# 	local -x VTK_SMP_BACKEND_IN_USE="OpenMP"
	elif use threads; then
		local -x VTK_SMP_BACKEND_IN_USE="STDThread"
	else
		local -x VTK_SMP_BACKEND_IN_USE="Sequential"
	fi

	local -a CMAKE_SKIP_TESTS

	if [[ "${CMAKE_RUN_OPTIONAL_TESTS:=no}" != "yes" ]]; then
		local -a REALLY_BAD_TESTS BAD_TESTS RANDOM_FAIL_TESTS

		# don't work at all
		REALLY_BAD_TESTS=(
			# (Failed)
			"^VTK::ChartsCoreCxx-TestLinePlot3D$"
			"^VTK::CommonDataModelCxx-TestHyperTreeGridGeometricLocator$"
			"^VTK::FiltersCoreCxx-TestImplicitPolyDataDistanceCube$"
			"^VTK::FiltersCorePython-TestSphereTreeFilter$"
			"^VTK::FiltersFlowPathsCxx-TestEvenlySpacedStreamlines2D$"
			"^VTK::FiltersFlowPathsCxx-TestParticleTracers$"
			"^VTK::FiltersGeneralCxx-TestContourTriangulatorHoles$"
			"^VTK::IOExportGL2PSCxx-TestGL2PSBillboardTextActor3D"
			"^VTK::IOExportGL2PSCxx-TestGL2PSExporterRaster"
			"^VTK::IOExportGL2PSCxx-TestGL2PSExporterVolumeRaster"
			"^VTK::IOExportGL2PSCxx-TestGL2PSLabeledDataMapper"
			"^VTK::IOExportGL2PSCxx-TestGL2PSTextActor"
			"^VTK::IOExportGL2PSCxx-TestGL2PSTextMapper"
			"^VTK::RenderingCorePython-pickImageData$"
			"^VTK::RenderingExternalCxx-TestGLUTRenderWindow$"
			"^VTK::RenderingFreeTypeFontConfigCxx-TestSystemFontRendering$"
			"^VTK::RenderingOpenGL2Cxx-TestGlyph3DMapperPickability$"

			# (Failed)
			"^VTK::FiltersParallelDIY2Cxx-MPI-TestProbeLineFilter$"
			"^VTK::FiltersSourcesCxx-MPI-TestRandomHyperTreeGridSourceMPI3$"

			# (Subprocess aborted)
			# File missing? ExternalData/Testing/Data/MotionFX/position_file/Sprocket_New.prn
			"VTK::IOMotionFXCxx-TestMotionFXCFGReaderPositionFile$"
		)

		# don't work in src_test but when on their own
		BAD_TESTS=(
			# (Failed)
			"^VTK::FiltersCoreCxx-TestQuadricDecimationMaximumError$"
			"^VTK::GUISupportQtCxx-TestQVTKOpenGLNativeWidgetWithChartHistogram2D$"
			"^VTK::GUISupportQtCxx-TestQVTKOpenGLStereoWidgetWithDisabledInteractor$"
			"^VTK::GUISupportQtCxx-TestQVTKOpenGLWidgetWithChartHistogram2D$"
			"^VTK::GUISupportQtCxx-TestQVTKOpenGLWindowWithDisabledInteractor$"
			"^VTK::GUISupportQtCxx-TestQVTKRenderWidgetWithChartHistogram2D$"
			"^VTK::GUISupportQtQuickCxx-TestQQuickVTKItem_1$" # QT-6.10.3 maybe?
			"^VTK::GUISupportQtQuickCxx-TestQQuickVTKItem_2$" # QT-6.10.3 maybe?
			"^VTK::GUISupportQtQuickCxx-TestQQuickVTKItem_3$" # QT-6.10.3 maybe?
			"^VTK::InteractionWidgetsCxx-TestFinitePlaneWidget$"
			"^VTK::InteractionWidgetsCxx-TestResliceCursorWidget2$"
			"^VTK::InteractionWidgetsCxx-TestResliceCursorWidget3$"
			"^VTK::InteractionWidgetsPython-TestTensorWidget2$"
			"^VTK::RenderingCoreCxx-TestCompositePolyDataMapperCameraShiftScale$"
			"^VTK::RenderingOpenGL2Cxx-TestCameraShiftScale$"
			"^VTK::RenderingOpenGL2Cxx-TestFluidMapper$"

			# The following tests did not run:
			"^VTK::RenderingCoreCxx-TestInteractorTimers$"

			# The following tests FAILED:
			# (Subprocess aborted)
			"^VTK::CommonDataModelCxx-quadraticIntersection$"
			"^VTK::RenderingCoreCxx-TestCompositePolyDataMapperBlockOpacities$"
			"^VTK::RenderingCoreCxx-TestCompositePolyDataMapperToggleScalarVisibilities$"
		)

		if use egl; then
			REALLY_BAD_TESTS+=(
				# The following tests did not run:
				# (Skipped)
				"^VTK::IOMovieCxx-TestAVIWriter$"
				"^VTK::IOMovieCxx-TestMP4Writer$"
			)
		else
			BAD_TESTS+=(
				# (Failed)
				# needs OSMesa or gles?
				"^VTK::CommonDataModelCxx-TestBezier$"
			)
		fi

		if use gles2; then
			BAD_TESTS+=(
				# (Failed)
				"^VTK::RenderingVolumeOpenGL2Cxx-TestGPURayCastDepthPeelingBoxWidget$"
				"^VTK::IOImportCxx-OBJImport-MixedOrder1$"
				"^VTK::IOImportCxx-OBJImport-MTLwithoutTextureFile$"
				"^VTK::GUISupportQtCxx-TestQVTKOpenGLStereoWidgetWithMSAA$"
				"^VTK::GUISupportQtCxx-TestQVTKOpenGLNativeWidgetWithMSAA$"
				"^VTK::GUISupportQtCxx-TestQVTKOpenGLWindowWithMSAA$"
				"^VTK::GUISupportQtCxx-TestQVTKRenderWidgetWithMSAA$"
				"^VTK::GUISupportQtCxx-TestQVTKOpenGLWidgetWithMSAA$"
				"^VTK::InteractionWidgetsCxx-BoxWidget$"
				"^VTK::InteractionWidgetsCxx-BoxWidget2$"
				"^VTK::InteractionWidgetsCxx-TestBrokenLineWidget$"
				"^VTK::InteractionWidgetsCxx-TestCamera3DWidget$"
				"^VTK::InteractionWidgetsCxx-TestLightWidget$"
				"^VTK::InteractionWidgetsCxx-TestPickingManagerSeedWidget$"
				"^VTK::InteractionWidgetsCxx-TestSphereWidget2CenterCursor$"
				"^VTK::InteractionWidgetsCxx-TestSphereWidgetZoomInOut$"
				"^VTK::InteractionWidgetsCxx-TestSplineWidget$"
				"^VTK::InteractionWidgetsCxx-TestTextRepresentationWithBorders$"
				"^VTK::InteractionWidgetsCxx-TestDijkstraGraphGeodesicPath$"
				"^VTK::RenderingVolumeCxx-TestGPURayCastMapperRectilinearGrid$"
				"^VTK::RenderingAnnotationCxx-TestAxisActor2D$"
				"^VTK::RenderingAnnotationCxx-TestCubeAxes2DMode$"
				"^VTK::RenderingAnnotationCxx-TestPolarAxes2D$"
				"^VTK::RenderingAnnotationCxx-TestPolarAxes2DDefault$"
				"^VTK::RenderingAnnotationCxx-TestXYPlotActor$"
				"^VTK::FiltersGeometryPreviewCxx-TestPointSetStreamer$"
				"^VTK::FiltersFlowPathsCxx-TestBSPTree$"
				"^VTK::FiltersFlowPathsCxx-TestBSPTreeWithGhostArrays$"
				"^VTK::FiltersFlowPathsCxx-TestStreamSurface$"
				"^VTK::FiltersFlowPathsCxx-TestVectorFieldTopology$"
				"^VTK::FiltersFlowPathsCxx-TestVectorFieldTopologyAMR$"
				"^VTK::FiltersModelingCxx-TestQuadRotationalExtrusion$"
				"^VTK::FiltersModelingCxx-TestQuadRotationalExtrusionMultiBlock$"
				"^VTK::FiltersModelingCxx-TestRotationalExtrusion$"
				"^VTK::FiltersModelingCxx-TestRotationalExtrusion2$"
				"^VTK::RenderingOpenGL2Cxx-TestCoincident$"
				"^VTK::RenderingOpenGL2Cxx-TestMultiTexturing$"
				"^VTK::RenderingOpenGL2Cxx-TestMultiTexturingInterpolateScalars$"
				"^VTK::RenderingOpenGL2Cxx-TestPBRClearCoat$"
				"^VTK::RenderingOpenGL2Cxx-TestSpherePoints$"
				"^VTK::RenderingOpenGL2Cxx-TestSphereVertex$"
				"^VTK::RenderingOpenGL2Cxx-TestValuePassFloatingPoint$"
				"^VTK::RenderingOpenGL2Cxx-TestValuePassFloatingPoint2$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2D$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DAxisReflectionXCenter$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DAxisReflectionXCenterMaterial$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DAxisReflectionYCenter$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DAxisReflectionYCenterMaterial$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DIJK$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DMaterial$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DMaterialIJK$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DVector$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DVectorAxisReflectionXCenter$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DVectorAxisReflectionYCenter$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary3DContour$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary3DContourDecomposePolyhedra$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary3DContourImplicit$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary2D$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary2DBiMaterial$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary2DFullMaterialBits$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary2DMaterial$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary2DMaterialBits$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DAxisClipBox$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DAxisReflectionXCenter$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DAxisReflectionXCenterMaterial$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DCellCenters$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DCellCentersMaterial$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DClip$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DContour$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DContourMaterial$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DDualContour$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DDualContourMaterial$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DPlaneCutter$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DPlaneCutterDual$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DPlaneCutterDualMaterial$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DPlaneCutterMaterial$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernarySphereMaterial$"
				"^VTK::RenderingCoreCxx-RGrid$"
				"^VTK::RenderingCoreCxx-TestCompositePolyDataMapperPartialFieldData$"
				"^VTK::RenderingCoreCxx-TestEdgeFlags$"
				"^VTK::RenderingCoreCxx-TestGlyph3DMapperOrientationArray$"
				"^VTK::RenderingCoreCxx-TestGlyph3DMapperQuaternionArray$"
				"^VTK::RenderingCoreCxx-TestPolyDataMapperNormals$"
				"^VTK::RenderingCoreCxx-TestRenderLinesAsTubes$"
				"^VTK::FiltersSourcesCxx-TestRandomHyperTreeGridSource$"
				"^VTK::AcceleratorsVTKmFiltersCxx-TestVTKMPolyDataNormals$"
				"^VTK::FiltersGeneralCxx-TestYoungsMaterialInterface$"
				"^VTK::FiltersGeometryCxx-TestLinearToQuadraticCellsFilter$"
				"^VTK::CommonDataModelCxx-TestKdTreeRepresentation$"
			)
		fi

		if use video_cards_zink; then
			local -x MESA_LOADER_DRIVER_OVERRIDE="zink"
		else
			REALLY_BAD_TESTS+=(
				# these fail when run using OpenGL4.5, e.g. llvmpipe
				# (Failed)
				"^VTK::FiltersGeneralCxx-TestLoopBooleanPolyDataFilter$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGrid3DIntercepts$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGrid3DInterface$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2D$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DAxisClipBox$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DAxisClipEllipse$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DAxisClipPlanes$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DAxisReflectionXCenter$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DAxisReflectionXCenterMaterial$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DAxisReflectionYCenter$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DDepthLimiter$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DDepthLimiterMaterial$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DThresholdDeep$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DThresholdImplicit$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DThresholdMaterial$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DThresholdMaterialDeep$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DThresholdMaterialImplicit$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DVectorAxisReflectionXCenter$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DVectorAxisReflectionYCenter$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary3DGeometry$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary2D$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary2DBiMaterial$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary2DMaterial$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DAxisClipCylinder$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DAxisClipPlanes$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DAxisCut$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DAxisCutMaterial$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DAxisReflectionXCenter$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DAxisReflectionXCenterMaterial$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DAxisReflectionYZCenter$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DAxisReflectionYZCenterMaterial$"
				"^VTK::ViewsInfovisCxx-TestIcicleView$"
				"^VTK::ViewsInfovisCxx-TestInteractorStyleTreeMapHover$"
				"^VTK::ViewsInfovisCxx-TestNetworkViews$"
				"^VTK::ViewsInfovisCxx-TestRenderView$"
				"^VTK::ViewsInfovisCxx-TestTreeMapView$"
				"^VTK::ViewsInfovisCxx-TestTreeRingView$"
			)

			BAD_TESTS+=(
				"^VTK::FiltersAMRCxx-TestAMRSliceFilterCellData$"
				"^VTK::FiltersCoreCxx-Test3DLinearGridPlaneCutterCellData$"
				"^VTK::FiltersCoreCxx-TestPolyDataTangents$"
				"^VTK::FiltersExtractionCxx-TestExtraction$"
				"^VTK::FiltersExtractionCxx-TestExtractionExpression$"
				"^VTK::FiltersGeneralCxx-TestClipClosedSurface1$"
				"^VTK::FiltersGeneralCxx-TestClipClosedSurface2$"
				"^VTK::FiltersGeneralCxx-TestDateToNumeric$"
				"^VTK::FiltersGeneralCxx-TestYoungsMaterialInterface$"
				"^VTK::FiltersGeometryCxx-TestDataSetRegionSurfaceFilter$"
				"^VTK::FiltersHybridCxx-TemporalStatistics$"
				"^VTK::FiltersHybridCxx-TestDepthSortPolyData$"
				"^VTK::FiltersHybridCxx-TestHyperTreeGridBinary2DAdaptiveDataSetSurfaceFilter$"
				"^VTK::FiltersHybridCxx-TestHyperTreeGridBinary2DAdaptiveDataSetSurfaceFilterMaterial$"
				"^VTK::FiltersHybridCxx-TestHyperTreeGridTernary3DAdaptiveDataSetSurfaceFilter$"
				"^VTK::FiltersHybridCxx-TestHyperTreeGridTernary3DAdaptiveDataSetSurfaceFilterMaterial$"
				"^VTK::FiltersHybridCxx-TestHyperTreeGridTernary3DToUnstructuredAdaptiveDataSetSurfaceFilter$"
				"^VTK::FiltersHybridCxx-TestTemporalFractal$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGrid2DInterfaceShift$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DAxisReflectionYCenterMaterial$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DCellCenters$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DCellCentersMaterial$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DContour$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DContourMaterial$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DIJK$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DInterfaceMaterial$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DMaterial$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DMaterialIJK$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DThreshold$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinary2DVector$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinaryClipPlanes$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinaryEllipseMaterial$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridBinaryHyperbolicParaboloidMaterial$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary2DFullMaterialBits$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary2DMaterialBits$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DGeometry$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DGeometryMaterial$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DGeometryMaterialBits$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DPlaneCutter$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DPlaneCutterMaterial$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DThreshold$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DThresholdDeep$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DThresholdImplicit$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DThresholdMaterial$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DThresholdMaterialDeep$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DThresholdMaterialImplicit$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DUnstructured$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernary3DUnstructuredMaterial$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernaryHyperbola$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernarySphereMaterial$"
				"^VTK::FiltersHyperTreeCxx-TestHyperTreeGridTernarySphereMaterialReflections$"
				"^VTK::FiltersModelingCxx-TestCollisionDetectionAllContacts$"
				"^VTK::FiltersModelingCxx-TestCollisionDetectionHalfContacts$"
				"^VTK::FiltersModelingCxx-TestLinearCellExtrusion$"
				"^VTK::FiltersModelingCxx-TestNamedColorsIntegration$"
				"^VTK::IOChemistryCxx-TestVASPTessellationReader$"
				"^VTK::IOGeometryCxx-TestOpenFOAMReaderFaceZone$"
				"^VTK::IOIOSSCxx-TestIOSSExodusParallelWriter$"
				"^VTK::IOOCCTCxx-TestOCCTReader$"
				"^VTK::IOXMLCxx-TestXMLHyperTreeGridIOInterface$"
				"^VTK::IOXMLCxx-TestXMLPieceDistribution$"
				"^VTK::InfovisLayoutCxx-TestCirclePackLayoutStrategy$"
				"^VTK::InfovisLayoutCxx-TestTreeMapLayoutStrategy$"
				"^VTK::InteractionWidgetsCxx-TestButtonWidgetMultipleViewports$"
				"^VTK::InteractionWidgetsCxx-TestDisplaySizedImplicitPlaneWidget$"
				"^VTK::InteractionWidgetsCxx-TestHandleWidget$"
				"^VTK::InteractionWidgetsCxx-TestImplicitPlaneWidget$"
				"^VTK::InteractionWidgetsCxx-TestImplicitPlaneWidget2$"
				"^VTK::InteractionWidgetsCxx-TestImplicitPlaneWidget2LockNormalToCamera$"
				"^VTK::InteractionWidgetsCxx-TestImplicitPlaneWidget2b$"
				"^VTK::RenderingAnnotationCxx-TestScalarBarAboveBelow$"
				"^VTK::RenderingCoreCxx-TestColorByCellDataStringArray$"
				"^VTK::RenderingCoreCxx-TestColorByStringArrayDefaultLookupTable$"
				"^VTK::RenderingCoreCxx-TestCompositePolyDataMapperOverrideLUT$"
				"^VTK::RenderingCoreCxx-TestCompositePolyDataMapperOverrideScalarArray$"
				"^VTK::RenderingCoreCxx-TestCompositePolyDataMapperPartialFieldData$"
				"^VTK::RenderingCoreCxx-TestMixedGeometryCellScalars$"
				"^VTK::RenderingCoreCxx-TestTilingCxx$"
		)
		fi

		if use vtkm && use cuda; then
			REALLY_BAD_TESTS+=(
				# (Subprocess aborted)
				"^VTK::AcceleratorsVTKmFiltersCxx-TestVTKMAbort$"
				"^VTK::AcceleratorsVTKmFiltersCxx-TestVTKMClip$"
				"^VTK::AcceleratorsVTKmFiltersCxx-TestVTKMClipWithImplicitFunction$"
				"^VTK::AcceleratorsVTKmFiltersPython-TestVTKMSlice$"

				# cuda-13?
				"^VTK::AcceleratorsVTKmFiltersCxx-TestVTKMSlice$"
			)
		fi

		if use rendering && use python && has_version '>=dev-python/matplotlib-3.11'; then
			REALLY_BAD_TESTS+=(
				"^VTK::RenderingMatplotlibCxx-TestContextMathTextImage$"
				"^VTK::RenderingMatplotlibCxx-TestRenderString$"
				"^VTK::RenderingMatplotlibCxx-TestStringToPath$"
				"^VTK::RenderingMatplotlibCxx-TestScalarBarCombinatorics$"
				"^VTK::RenderingMatplotlibPython-TestRenderString$"
				"^VTK::RenderingMatplotlibPython-TestStringToPath$"
			)

			if use truetype; then
				REALLY_BAD_TESTS+=(
					"^VTK::RenderingFreeTypeCxx-TestMathTextFonts$"
					"^VTK::RenderingFreeTypeCxx-TestMathTextFreeTypeTextRenderer$"
					"^VTK::RenderingFreeTypeCxx-TestFreeTypeTextMapper$"
					"^VTK::RenderingFreeTypeCxx-TestFreeTypeTextMapperWithColumns$"
					"^VTK::RenderingFreeTypeCxx-TestFontDPIScaling$"
				)
			fi
		fi

		RANDOM_FAIL_TESTS=(
			# (Failed)
			"VTK::FiltersVerdictCxx-TestCellQuality$"

			# (Subprocess aborted)
			"^VTK::RenderingLICOpenGL2Cxx-SurfaceLICCurvedContrastEnhancedColorMappedSmallGrainMask$"
			"^VTK::RenderingLICOpenGL2Cxx-SurfaceLICPlanarContrastEnhanced$"
		)

		CMAKE_SKIP_TESTS+=(
			"${REALLY_BAD_TESTS[@]}"
			"${BAD_TESTS[@]}"
			"${RANDOM_FAIL_TESTS[@]}"
		)
	fi

	CMAKE_SKIP_TESTS+=(
		# requires VTK_USE_MICROSOFT_MEDIA_FOUNDATION
		"^VTK::IOMovieCxx-Test" # Skipped
	)

	if use openmp; then
		CMAKE_SKIP_TESTS+=(
			"^VTK::CommonCoreCxx-TestSMP$"
		)
	fi

	# TODO Why?
	local -x CC="$(tc-getCC)"
	local -x CXX="$(tc-getCXX)"

	myctestargs=(
		--test-timeout 300
		--repeat until-pass:15
		--output-on-failure
	)

	local -x VTK_DEFAULT_OPENGL_WINDOW
	if use egl; then
		VTK_DEFAULT_OPENGL_WINDOW="vtkEGLRenderWindow"
	# elif use osmesa; then
	# 	VTK_DEFAULT_OPENGL_WINDOW="vtkOSOpenGLRenderWindow"
	else
		VTK_DEFAULT_OPENGL_WINDOW="vtkXOpenGLRenderWindow"
	fi

	if use egl; then
		# freedesktop specifications mandate that the definition
		# of XDG_SESSION_TYPE should be respected
		# local -x XDG_SESSION_TYPE="wayland"
		# local -x GDK_BACKEND="wayland"
		# local -x QT_QPA_PLATFORM="wayland-egl"
		# local -x MOZ_ENABLE_WAYLAND=1

		xdg_environment_reset

		local -x WAYLAND_DISPLAY="wayland-${P}"
		local westonargs=(
			--backend="headless-backend.so"
			--socket="${WAYLAND_DISPLAY}"
			--idle-time="0"
			--xwayland
			--width="1280"
			--height="1024"
			--refresh-rate="144000"
		)
		weston "${westonargs[@]}" & # MHz
		local compositor=$!

		eqawarn "running at ${compositor}"
	# elif use qt6; then
	# 	local -x QT_QPA_PLATFORM="offscreen"
	fi

	local -x MESA_SHADER_CACHE_DISABLE=true

	eqawarn "MESA_LOADER_DRIVER_OVERRIDE: ${MESA_LOADER_DRIVER_OVERRIDE}"
	eqawarn "VTK_DEFAULT_OPENGL_WINDOW:   ${VTK_DEFAULT_OPENGL_WINDOW}"

	# local -x WL=tinywl
	if use egl; then
		cmake_src_test
	else
		virtx \
			cmake_src_test
	fi

	# unset CMAKE_SKIP_TESTS
	# myctestargs=( -N )
	# cmake_src_test

	if use egl; then
		eqawarn "killing ${compositor}"
		kill "${compositor}" || die
	fi

	eqawarn "MESA_LOADER_DRIVER_OVERRIDE: ${MESA_LOADER_DRIVER_OVERRIDE}"
	eqawarn "VTK_DEFAULT_OPENGL_WINDOW:   ${VTK_DEFAULT_OPENGL_WINDOW}"

	# die "the end"
}

src_install() {
	use web && webapp_src_preinst

	# Stop web page images from being compressed
	if use doc; then
		HTML_DOCS=( "${WORKDIR}/html/." )
	fi

	cmake_src_install

	use java && java-pkg_regjar "${ED}/usr/share/${PN}/${PN}.jar"

	# install examples
	if use examples; then
		einfo "Installing examples"
		mv -v {E,e}xamples || die
		dodoc -r examples
		docompress -x "/usr/share/doc/${PF}/examples"

		einfo "Installing datafiles"
		insinto "/usr/share/${PN}/data"
		doins -r "${S}/.ExternalData"
	fi

	use python && python_optimize

	use web && webapp_src_install
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

pkg_info() {
	# if [[ -v DISPLAY ]]; then
		# for virtx
		xdg_environment_reset

		if use video_cards_zink; then
			local -x MESA_LOADER_DRIVER_OVERRIDE="zink"
		fi

		vtk_add_sandbox
		nonfatal virtx "/usr/bin/vtkProbeOpenGLVersion-$(ver_cut 1-2)"
	# fi
}
