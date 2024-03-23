# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

TOOLCHAIN_PATCH_DEV="sam"
PATCH_GCC_VER="10.5.0"
PATCH_VER="6"
MUSL_VER="2"
MUSL_GCC_VER="10.5.0"
PYTHON_COMPAT=( python3_{10..11} )

if [[ ${PV} == *.9999 ]] ; then
	MY_PV_2=$(ver_cut 2)
	MY_PV_3=1
	if [[ ${MY_PV_2} == 0 ]] ; then
		MY_PV_2=0
		MY_PV_3=0
	else
		MY_PV_2=$((${MY_PV_2} - 1))
	fi

	# e.g. 12.2.9999 -> 12.1.1
	TOOLCHAIN_GCC_PV=$(ver_cut 1).${MY_PV_2}.${MY_PV_3}
elif [[ -n ${TOOLCHAIN_GCC_RC} ]] ; then
	# Cheesy hack for RCs
	MY_PV=$(ver_cut 1).$((($(ver_cut 2) + 1))).$((($(ver_cut 3) - 1)))-RC-$(ver_cut 5)
	MY_P=${PN}-${MY_PV}
	GCC_TARBALL_SRC_URI="mirror://gcc/snapshots/${MY_PV}/${MY_P}.tar.xz"
	TOOLCHAIN_SET_S=no
	S="${WORKDIR}"/${MY_P}
fi

inherit toolchain

if tc_is_live ; then
	# Needs to be after inherit (for now?), bug #830908
	EGIT_BRANCH=releases/gcc-$(ver_cut 1)
elif [[ -z ${TOOLCHAIN_USE_GIT_PATCHES} ]] ; then
	# Don't keyword live ebuilds
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
	:;
fi

RDEPEND=""
BDEPEND="${CATEGORY}/binutils"

src_prepare() {
	local p upstreamed_patches=(
		# add them here
	)
	for p in "${upstreamed_patches[@]}"; do
		rm -v "${WORKDIR}/patch/${p}" || die
	done

	if has_version '>=sys-libs/glibc-2.32-r1'; then
		rm -v "${WORKDIR}/patch/23_all_disable-riscv32-ABIs.patch" || die
	fi

	toolchain_src_prepare
}
