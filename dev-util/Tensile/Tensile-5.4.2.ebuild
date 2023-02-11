# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools
ROCM_VERSION=${PV}
inherit cmake distutils-r1 llvm prefix rocm

LLVM_MAX_SLOT=15

DESCRIPTION="Stretching GPU performance for GEMMs and tensor contractions"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/Tensile"
SRC_URI="https://github.com/ROCmSoftwarePlatform/Tensile/archive/rocm-${PV}.tar.gz -> rocm-Tensile-${PV}.tar.gz"
S="${WORKDIR}/${PN}-rocm-${PV}"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
IUSE="client"
REQUIRED_USE="client? ( ${ROCM_REQUIRED_USE} )"

# Not compatible with recent versions of pytest
RESTRICT="test"

RDEPEND="${PYTHON_DEPS}
	dev-cpp/msgpack-cxx
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]
	dev-util/hip
	>=dev-util/rocm-smi-4.3.0
	sys-devel/clang:${LLVM_MAX_SLOT}
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-4.3.0-output-commands.patch
		  "${FILESDIR}"/${PN}-5.4.2-gfx1031.patch
		  "${FILESDIR}"/${PN}-5.4.2-fix-arch-parse.patch
		  "${FILESDIR}"/${PN}-5.4.2-use-ninja.patch
		  "${FILESDIR}"/0001-Change-cmake-name-for-msgpack-5-release.patch
	  )

CMAKE_USE_DIR="${S}/${PN}/Source"

src_prepare() {
	distutils-r1_src_prepare
	sed -e "s,\@LLVM_PATH\@,$(get_llvm_prefix ${LLVM_MAX_SLOT}),g" \
		"${FILESDIR}"/${PN}-5.4.2-gentoopath.patch > "${S}"/gentoopath.patch || die
	eapply $(prefixify_ro "${S}"/gentoopath.patch)

	pushd ${PN} || die

	sed -e "/ROCM_SMI_ROOT/s,lib,$(get_libdir)," \
		-i Source/cmake/FindROCmSMI.cmake || die
	sed -r -e "/TENSILE_USE_LLVM/s/ON/OFF/" \
		-i Source/CMakeLists.txt || die
	sed -e "/chmod 755/d" -i Source/TensileCreateLibrary.cmake || die # remove chmod 755 on

	# ${Tensile_ROOT}/bin does not exists; call command directly
	sed -e "s,\${Tensile_ROOT}/bin/,,g" -i Source/TensileCreateLibrary.cmake cmake/TensileConfig.cmake || die

	local Tensile_share_dir="\"${EPREFIX}/usr/share/${PN}\""
	sed -e "/HipClangVersion/s/0.0.0/$(hipconfig -v)/" -i Common.py || die

	sed -e "s,os.path.dirname(os.path.realpath(__file__)),${Tensile_share_dir},g" \
		-i ReplacementKernels.py Common.py ${PN}.py || die

	sed -e "s|os\.path\.dirname.*$|\"${EPREFIX}/usr/share/Tensile/Source\", end='')|" -i __init__.py || die

	popd || die

	sed -e "/package_data/d" -e "/data_files/d" -i setup.py || die
	use client && PATCHES= cmake_src_prepare  # do not apply patches again in cmake_src_prepare
}

src_configure() {
	distutils-r1_src_configure
	if use client; then
		local mycmakeargs=(
			-DCMAKE_SKIP_RPATH=ON
			-DTENSILE_USE_MSGPACK=ON
			-DTENSILE_USE_LLVM=ON
			-DTensile_LIBRARY_FORMAT=msgpack
			-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		)
		CXX=hipcc cmake_src_configure
	fi
}

src_compile() {
	distutils-r1_src_compile
	use client && cmake_src_compile
}

python_install() {
	distutils-r1_python_install

	python_moduleinto Tensile
	pushd Tensile || die
	python_domodule Components
	python_newexe Utilities/merge.py ${PN}-merge
}

src_install() {
	distutils-r1_src_install

	pushd ${PN} || die
	insinto /usr/share/${PN}
	doins -r Configs Perf ReplacementKernels ReplacementKernels-cov3 Source CustomKernels
	insinto /usr/$(get_libdir)/cmake/${PN}
	doins cmake/*.cmake

	if use client; then
		pushd "${BUILD_DIR}" || die
		dobin client/tensile_client
	fi
}
