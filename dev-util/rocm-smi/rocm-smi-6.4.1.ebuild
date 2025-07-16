# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} python3_13t )

inherit cmake linux-info optfeature python-r1

DESCRIPTION="ROCm System Management Interface Library"
HOMEPAGE="https://github.com/ROCm/rocm_smi_lib"

if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ROCm/rocm_smi_lib"
	EGIT_BRANCH="master"
else
	SRC_URI="https://github.com/ROCm/rocm_smi_lib/archive/rocm-${PV}.tar.gz -> rocm-smi-${PV}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/rocm_smi_lib-rocm-${PV}"
fi

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	sys-kernel/linux-headers
	x11-libs/libdrm
"

PATCHES=(
	"${FILESDIR}"/${PN}-5.7.1-no-strip.patch
	"${FILESDIR}"/${PN}-5.7.1-remove-example.patch
	"${FILESDIR}"/${PN}-6.4.1-set-soversion.patch
	"${FILESDIR}"/${PN}-6.3.0-fix-flags.patch
	"${FILESDIR}"/${PN}-6.4.1-log-exceptions.patch
)

CONFIG_CHECK="~HSA_AMD ~DRM_AMDGPU"

src_prepare() {
	cmake_src_prepare

	sed -e "s/@VERSION_MAJOR@/$(ver_cut 1)/" \
		-e "s/@VERSION_MINOR@/$(ver_cut 2)/" \
		-e "s/@VERSION_PATCH@/$(ver_cut 3)/" \
		-i CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DFILE_REORG_BACKWARD_COMPATIBILITY=OFF
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	python_foreach_impl python_newscript python_smi_tools/rocm_smi.py rocm-smi
	python_foreach_impl python_domodule python_smi_tools/rsmiBindings.py
	python_foreach_impl python_domodule python_smi_tools/rsmiBindingsInit.py

	mv "${ED}"/usr/share/doc/rocm_smi "${ED}/usr/share/doc/${PF}" || die
}

pkg_postinst() {
	optfeature "vendor and device names instead of hex device IDs" sys-apps/hwdata
}
