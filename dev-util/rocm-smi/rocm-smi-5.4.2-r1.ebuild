# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} )

inherit cmake python-r1

DESCRIPTION="ROCm System Management Interface Library"
HOMEPAGE="https://github.com/RadeonOpenCompute/rocm_smi_lib"

if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/rocm_smi_lib"
	EGIT_BRANCH="master"
else
	SRC_URI="https://github.com/RadeonOpenCompute/rocm_smi_lib/archive/rocm-${PV}.tar.gz -> rocm-smi-${PV}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/rocm_smi_lib-rocm-${PV}"
fi

LICENSE="MIT NCSA-AMD"
SLOT="0/$(ver_cut 1-2)"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND=""
RDEPEND="${PYTHON_DEPS}"
BDEPEND=""

PATCHES=(
	"${FILESDIR}"/${PN}-5.0.2-gcc12-memcpy.patch
	"${FILESDIR}"/${PN}-5.4.2-detect-builtin-amdgpu.patch
	"${FILESDIR}"/${PN}-5.4.2-fix-readonly-object.patch
)

src_prepare() {
	sed -e "/LICENSE.txt/d" -i CMakeLists.txt || die
	sed -e "/^path_librocm = /c\path_librocm = '${EPREFIX}/usr/lib64/librocm_smi64.so'" \
		-i python_smi_tools/rsmiBindings.py || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCMAKE_DISABLE_FIND_PACKAGE_LATEX=ON
		-DFILE_REORG_BACKWARD_COMPATIBILITY=OFF
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	python_foreach_impl python_newscript python_smi_tools/rocm_smi.py rocm-smi
	python_foreach_impl python_domodule python_smi_tools/rsmiBindings.py
}
