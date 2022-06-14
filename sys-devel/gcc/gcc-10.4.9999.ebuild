# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

TOOLCHAIN_PATCH_SUFFIX="xz"
TOOLCHAIN_PATCH_DEV="sam"
PATCH_GCC_VER="10.4.0"
MUSL_GCC_VER="10.4.0"

if [[ $(ver_cut 3) == 9999 ]] ; then
	MY_PV_2=$(ver_cut 2)
	if [[ ${MY_PV_2} == 0 ]] ; then
		MY_PV_2=0
	else
		MY_PV_2=$(($(ver_cut 2) - 1))
	fi

	# e.g. 12.2.9999 -> 12.1.1
	TOOLCHAIN_GCC_PV=$(ver_cut 1).${MY_PV_2}.$(($(ver_cut 3) - 9998))
fi

inherit toolchain
# Needs to be after inherit (for now?), bug #830908
EGIT_BRANCH=releases/gcc-$(ver_cut 1)

# Don't keyword live ebuilds
if ! tc_is_live && [[ -z ${TOOLCHAIN_USE_GIT_PATCHES} ]] ; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
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
