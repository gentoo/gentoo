# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
ROCM_VERSION=6.3
CUDA_DEVICE_TARGETS=1

inherit cmake cuda python-any-r1 rocm

DESCRIPTION="Intel Open Image Denoise library"
HOMEPAGE="https://www.openimagedenoise.org https://github.com/RenderKit/oidn"

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/RenderKit/oidn.git"
	EGIT_BRANCH="master"
	EGIT_LFS="1"
	inherit git-r3
else
	SRC_URI="https://github.com/RenderKit/${PN}/releases/download/v${PV}/${P}.src.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 -arm ~arm64 -ppc ~ppc64 -x86" # 64-bit-only
fi

LICENSE="Apache-2.0"
SLOT="0/${PV}"
IUSE="apps cuda hip openimageio test"
REQUIRED_USE="
	test? ( apps )
"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-cpp/tbb:=
	dev-lang/ispc
	cuda? (
		dev-util/nvidia-cuda-toolkit:=
		dev-libs/cutlass
	)
	hip? (
		dev-util/hip:=
	)
	openimageio? ( media-libs/openimageio:= )
"
DEPEND="${RDEPEND}"
BDEPEND="${PYTHON_DEPS}"

PATCHES=(
	"${FILESDIR}/${PN}-2.3.3-amdgpu-targets.patch"
)

src_prepare() {
	if use cuda; then
		cuda_src_prepare
	fi

	if use hip; then
		# https://bugs.gentoo.org/930391
		sed "/-Wno-unused-result/s:): --rocm-path=${EPREFIX}/usr):" \
			-i devices/hip/CMakeLists.txt || die
	fi

	# do not fortify source -- bug 895018
	sed -e "s/-D_FORTIFY_SOURCE=2//g" -i {cmake/oidn_platform,external/mkl-dnn/cmake/SDL}.cmake || die

	# Don't de-bundle composable_kernel for two reasons:
	# 1. sci-libs/composable-kernel takes a very long time to compile and oidn only uses a subset of it.
	# 2. We've run into compilation issues when trying to debundle it. See #955869
	rm -r external/{cutlass,mkl-dnn} || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DOIDN_APPS="$(usex apps)"

		-DOIDN_LIBRARY_VERSIONED="yes"
		-DOIDN_DEVICE_CPU="yes"
		-DOIDN_DEVICE_CUDA="$(usex cuda)"
		-DOIDN_DEVICE_HIP="$(usex hip)"
		# -DOIDN_DEVICE_SYCL="$(usex sycl)"
	)

	if use apps; then
		mycmakeargs+=( -DOIDN_APPS_OPENIMAGEIO="$(usex openimageio)" )
	fi

	if use cuda; then
		export CUDAHOSTCXX="$(cuda_gccdir)"
	fi

	if use hip; then
		mycmakeargs+=(
			-DROCM_PATH="${EPREFIX}/usr"
			-DOIDN_DEVICE_HIP_COMPILER="${ESYSROOT}/usr/bin/hipcc" # use HIPHOSTCOMPILER
			-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		)
	fi

	cmake_src_configure
}

src_compile() {
	if use cuda; then
		addpredict /dev/char/
		cuda_add_sandbox
	fi

	cmake_src_compile
}

src_test() {
	if use cuda; then
		addpredict /dev/char/
		cuda_add_sandbox
	fi

	"${BUILD_DIR}"/oidnTest || die "There were test failures!"
}

src_install() {
	cmake_src_install

	if use hip || use cuda ; then
		# remove garbage in /var/tmp left by subprojects
		rm -r "${ED}"/var || die
	fi
}
