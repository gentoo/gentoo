# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=${PN%*-bin}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Ahead of Time (AOT) Triton Math Library (binary package)"
HOMEPAGE="https://github.com/ROCm/aotriton"

URI_PREFIX="https://github.com/ROCm/${MY_PN}/releases/download/${PV}"
SHIM_URI_PREFIX="${URI_PREFIX}/${MY_P}-manylinux_2_28_x86_64"
IMAGES_URI_PREFIX="${URI_PREFIX}/${MY_P}-images-amd"

# Download libs for all rocm releases (4mb each), but unpack only one.
SRC_URI="
	${SHIM_URI_PREFIX}-rocm6.4-shared.tar.gz
	${SHIM_URI_PREFIX}-rocm7.0-shared.tar.gz
	${SHIM_URI_PREFIX}-rocm7.1-shared.tar.gz
	${SHIM_URI_PREFIX}-rocm7.2-shared.tar.gz
	${SHIM_URI_PREFIX}-rocm7.16-shared.tar.gz

	amdgpu_targets_gfx90a? ( ${IMAGES_URI_PREFIX}-gfx90a.tar.gz )
	amdgpu_targets_gfx942? ( ${IMAGES_URI_PREFIX}-gfx942.tar.gz )
	amdgpu_targets_gfx950? ( ${IMAGES_URI_PREFIX}-gfx950.tar.gz )

	amdgpu_targets_gfx1100? ( ${IMAGES_URI_PREFIX}-gfx110x.tar.gz )
	amdgpu_targets_gfx1101? ( ${IMAGES_URI_PREFIX}-gfx110x.tar.gz )
	amdgpu_targets_gfx1102? ( ${IMAGES_URI_PREFIX}-gfx110x.tar.gz )
	amdgpu_targets_gfx1103? ( ${IMAGES_URI_PREFIX}-gfx110x.tar.gz )
	amdgpu_targets_gfx1150? ( ${IMAGES_URI_PREFIX}-gfx115x.tar.gz )
	amdgpu_targets_gfx1151? ( ${IMAGES_URI_PREFIX}-gfx115x.tar.gz )
	amdgpu_targets_gfx1152? ( ${IMAGES_URI_PREFIX}-gfx115x.tar.gz )
	amdgpu_targets_gfx1153? ( ${IMAGES_URI_PREFIX}-gfx115x.tar.gz )

	amdgpu_targets_gfx1200? ( ${IMAGES_URI_PREFIX}-gfx120x.tar.gz )
	amdgpu_targets_gfx1201? ( ${IMAGES_URI_PREFIX}-gfx120x.tar.gz )
"
S="${WORKDIR}/${MY_PN}"

LICENSE="MIT"
SLOT="0/${PV%b}"

KEYWORDS="-* ~amd64"

IUSE_TARGETS=(
	gfx90a
	gfx942
	gfx950
	gfx1100
	gfx1101
	gfx1102
	gfx1103
	gfx1150
	gfx1151
	gfx1152
	gfx1153
	gfx1200
	gfx1201
)
IUSE_TARGETS=( "${IUSE_TARGETS[@]/#/amdgpu_targets_}" )
IUSE="${IUSE_TARGETS[*]/#/+}"

RESTRICT="strip"
QA_PREBUILT="usr/lib*/libaotriton_v2.so.*"

# glibc & gcc:  linked with manylinux version, no rebuild required
# xz-utils:     used to decompress lzma blobs with kernels in runtime
# dev-util/hip: must be in sync with SRC_URI
#               and trigger reinstall on sub-slot change.
DEPEND="
	>=dev-util/hip-6.4:=
	<dev-util/hip-10.2:=
"
RDEPEND="
	${DEPEND}
	sys-libs/glibc
	sys-devel/gcc
	app-arch/xz-utils
"

src_unpack() {
	# *-rocmX.X-shared.tar.gz archives with host code have the same structure,
	# so decompression of all of them would overwrite files of each other.
	# Instead we decompress only one version for current dev-util/hip.
	# Archives are named after the HIP version (ROCm 10.1 ships HIP 7.16).
	local hipver=$(awk '
		$2 == "HIP_VERSION_MAJOR" { major = $3 }
		$2 == "HIP_VERSION_MINOR" { minor = $3 }
		END { print major "." minor }
	' "${ESYSROOT}"/usr/include/hip/hip_version.h || die)
	local shim="${MY_P}-manylinux_2_28_x86_64-rocm${hipver}-shared.tar.gz"
	has "${shim}" ${A} || die "${MY_P} has no build for HIP ${hipver}"
	unpack "${shim}"

	local file
	for file in ${A}; do
		[[ $file == *-gfx*.tar.gz ]] && unpack "${file}"
	done
}

src_prepare() {
	default

	# Shipped CMake files hard-code the prefix of the upstream build machine
	local prefix='"${CMAKE_CURRENT_LIST_DIR}/../../.." ABSOLUTE'
	sed -e "s:^set(_IMPORT_PREFIX \"[^\"]*\")$:get_filename_component(_IMPORT_PREFIX ${prefix}):" \
		-i lib/cmake/aotriton/aotriton-targets.cmake || die
	sed -e "s:\"[^\"]*/lib/libaotriton_v2:\"\${_IMPORT_PREFIX}/$(get_libdir)/libaotriton_v2:" \
		-i lib/cmake/aotriton/aotriton-targets-release.cmake || die
}

src_install() {
	doheader -r include/*

	insinto /usr/$(get_libdir)
	doins -r lib/*
}
