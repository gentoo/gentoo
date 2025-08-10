# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
ROCM_VERSION=${PV}
LLVM_COMPAT=( 20 )

inherit cmake distutils-r1 llvm-r1 prefix rocm

DESCRIPTION="Stretching GPU performance for GEMMs and tensor contractions"
HOMEPAGE="https://github.com/ROCm/Tensile"

if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ROCm/rocm-libraries.git"
	EGIT_BRANCH="develop"
	S="${WORKDIR}/${P}/shared/tensile"
	SLOT="0/6.4"
else
	SRC_URI="https://github.com/ROCm/Tensile/archive/rocm-${PV}.tar.gz -> rocm-Tensile-${PV}.tar.gz"
	S="${WORKDIR}/${PN}-rocm-${PV}"
	SLOT="0/$(ver_cut 1-2)"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
IUSE="client test"
REQUIRED_USE="client? ( ${ROCM_REQUIRED_USE} )"

# tests can freeze machine depending on gpu/kernel
RESTRICT="test"

RDEPEND="${PYTHON_DEPS}
	client? ( dev-libs/boost )
	>=dev-cpp/msgpack-cxx-6.0.0
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]
	dev-python/joblib[${PYTHON_USEDEP}]
	dev-util/hip:${SLOT}
	dev-util/rocm-smi:${SLOT}
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}
	')
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		dev-python/pytest-forked[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/filelock[${PYTHON_USEDEP}]
		dev-python/joblib[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

CMAKE_USE_DIR="${S}/${PN}/Source"

src_prepare() {
	distutils-r1_src_prepare
	sed -e "s,\@LLVM_PATH\@,$(get_llvm_prefix),g" \
		"${FILESDIR}"/${PN}-5.7.1-gentoopath.patch > "${S}"/gentoopath.patch || die
	eapply $(prefixify_ro "${S}"/gentoopath.patch)

	# https://github.com/ROCm/rocm-libraries/issues/1133
	sed 's/\["Tensile"\]/__import__("setuptools").find_packages()/' \
		-i setup.py || die

	# https://github.com/ROCm/rocm-libraries/issues/944
	sed 's/amdclang/clang/g' -i Tensile/Utilities/Toolchain.py || die

	pushd ${PN} || die

	sed -e "/ROCM_SMI_ROOT/s,lib,$(get_libdir)," \
		-i Source/cmake/FindROCmSMI.cmake || die
	sed -r -e "/TENSILE_USE_LLVM/s/ON/OFF/" \
		-i Source/CMakeLists.txt || die

	# ${Tensile_ROOT}/bin does not exists; call command directly
	sed -e "s,\${Tensile_ROOT}/bin/,,g" -i cmake/TensileConfig.cmake || die

	local Tensile_share_dir="\"${EPREFIX}/usr/share/${PN}\""
	sed -e "/HipClangVersion/s/0.0.0/$(hipconfig -v)/" -i Common.py || die

	sed -e "s,os.path.dirname(os.path.realpath(__file__)),${Tensile_share_dir},g" \
		-i ReplacementKernels.py Common.py ${PN}.py || die

	sed -e "s|os\.path\.dirname.*$|\"${EPREFIX}/usr/share/Tensile/Source\", end='')|" -i __init__.py || die

	# bug 949817: fix v_dot4_i32_i8 syntax for clang-20
	sed  's/ op_sel:\[0,0\] op_sel_hi:\[1,1\]//' -i Components/MAC_I8X4.py || die

	popd || die

	sed -e "/package_data/d" -e "/data_files/d" -i setup.py || die
	use client && PATCHES='' cmake_src_prepare  # do not apply patches again in cmake_src_prepare
}

src_configure() {
	rocm_use_hipcc

	distutils-r1_src_configure
	if use client; then
		local mycmakeargs=(
			-DCMAKE_SKIP_RPATH=ON
			-DTENSILE_USE_MSGPACK=ON
			-DTENSILE_USE_LLVM=ON
			-DTensile_LIBRARY_FORMAT=msgpack
			-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		)
		cmake_src_configure
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
	python_domodule Utilities
	python_domodule TensileCreateLib
}

src_install() {
	distutils-r1_src_install

	pushd ${PN} || die
	insinto /usr/share/${PN}
	doins -r Configs Perf Source CustomKernels
	insinto /usr/$(get_libdir)/cmake/${PN}
	doins cmake/*.cmake

	if use client; then
		pushd "${BUILD_DIR}" || die
		dobin client/tensile_client
	fi
}

# Test suite fails to start without this
python_test() {
	export ROCM_PATH="${EPREFIX}/usr"
	epytest
}
