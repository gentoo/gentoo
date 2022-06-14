# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

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
)

src_prepare() {
	sed -e "/DESTINATION/s,\${OAM_NAME}/lib,$(get_libdir)," \
		-e "/DESTINATION/s,oam/include/oam,include/oam," -i oam/CMakeLists.txt || die
	sed -e "/link DESTINATION/,+1d" \
		-e "/DESTINATION/s,\${ROCM_SMI}/lib,$(get_libdir)," \
		-e "/bindings_link/,+3d" \
		-e "/rsmiBindings.py/,+1d" \
		-e "/DESTINATION/s,rocm_smi/include/rocm_smi,include/rocm_smi," -i rocm_smi/CMakeLists.txt || die
	sed -e "/LICENSE.txt/d" -e "s,\${ROCM_SMI}/lib/cmake,$(get_libdir)/cmake,g" -i CMakeLists.txt || die
	sed -e "/^path_librocm = /c\path_librocm = '${EPREFIX}/usr/lib64/librocm_smi64.so'" -i python_smi_tools/rsmiBindings.py || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCMAKE_DISABLE_FIND_PACKAGE_LATEX=ON
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	python_foreach_impl python_newexe python_smi_tools/rocm_smi.py rocm-smi
	python_foreach_impl python_domodule python_smi_tools/rsmiBindings.py
}
