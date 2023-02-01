# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )

ROCM_VERSION=${PV}

inherit cmake prefix python-any-r1 rocm

DESCRIPTION="Callback/Activity Library for Performance tracing AMD GPU's"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/roctracer.git"
SRC_URI="https://github.com/ROCm-Developer-Tools/roctracer/archive/rocm-${PV}.tar.gz -> rocm-tracer-${PV}.tar.gz"
S="${WORKDIR}/roctracer-rocm-${PV}"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/rocr-runtime:${SLOT}
	dev-util/hip:${SLOT}"
DEPEND="${RDEPEND}"
BDEPEND="
	$(python_gen_any_dep '
	dev-python/CppHeaderParser[${PYTHON_USEDEP}]
	dev-python/ply[${PYTHON_USEDEP}]
	')
"

PATCHES=( "${FILESDIR}"/roctracer-5.3.3-flat-lib-layout.patch
	"${FILESDIR}"/roctracer-5.3.3-do-not-install-test-files.patch
	"${FILESDIR}"/roctracer-5.3.3-Werror.patch )

python_check_deps() {
	python_has_version "dev-python/CppHeaderParser[${PYTHON_USEDEP}]" \
		"dev-python/ply[${PYTHON_USEDEP}]"
}

src_prepare() {
	cmake_src_prepare

	hprefixify script/*.py
	eapply $(prefixify_ro "${FILESDIR}"/${PN}-5.3.3-rocm-path.patch)
}

src_configure() {
	export ROCM_PATH="$(hipconfig -p)"
	local mycmakeargs=(
		-DCMAKE_MODULE_PATH="${EPREFIX}/usr/lib64/cmake/hip"
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DFILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DHIP_CXX_COMPILER=hipcc
	)

	cmake_src_configure
}

src_test() {
	check_amdgpu
	cd "${BUILD_DIR}" || die
	# if LD_LIBRARY_PATH not set, dlopen cannot find correct lib
	LD_LIBRARY_PATH="${EPREFIX}"/usr/lib64 bash run.sh || die
}
