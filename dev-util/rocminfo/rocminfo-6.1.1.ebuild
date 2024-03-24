# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
inherit cmake python-r1

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ROCm/rocminfo/"
	inherit git-r3
else
	SRC_URI="https://github.com/ROCm/rocminfo/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/rocminfo-rocm-${PV}"
fi

DESCRIPTION="ROCm Application for Reporting System Info"
HOMEPAGE="https://github.com/ROCm/rocminfo"
LICENSE="UoI-NCSA"
SLOT="0/$(ver_cut 1-2)"

RDEPEND=">=dev-libs/rocr-runtime-${PV}
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

PATCHES=(
	"${FILESDIR}/${PN}-6.0.0-detect-builtin-amdgpu.patch"
)

src_prepare() {
	sed -e "/CPACK_RESOURCE_FILE_LICENSE/d" -i CMakeLists.txt || die
	sed -e "/num_change_since_prev_pkg(/cset(NUM_COMMITS 0)" \
		-i cmake_modules/utils.cmake || die # Fix QA issue on "git not found"
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=( -DROCRTST_BLD_TYPE=Release )
	cmake_src_configure
}

src_install() {
	cmake_src_install
	rm "${ED}/usr/bin/rocm_agent_enumerator" || die
	python_foreach_impl python_doexe rocm_agent_enumerator "${BUILD_DIR}"/rocm_agent_enumerator
}
