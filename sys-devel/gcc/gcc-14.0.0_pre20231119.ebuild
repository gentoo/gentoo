# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

TOOLCHAIN_PATCH_DEV="sam"
PATCH_GCC_VER="14.0.0"
PATCH_VER="9"
MUSL_VER="1"
MUSL_GCC_VER="14.0.0"

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
	EGIT_BRANCH=master
elif [[ -z ${TOOLCHAIN_USE_GIT_PATCHES} ]] ; then
	# Don't keyword live ebuilds
	#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
	:;
fi

if [[ ${CATEGORY} != cross-* ]] ; then
	# Technically only if USE=hardened *too* right now, but no point in complicating it further.
	# If GCC is enabling CET by default, we need glibc to be built with support for it.
	# bug #830454
	RDEPEND="elibc_glibc? ( sys-libs/glibc[cet(-)?] )"
	DEPEND="${RDEPEND}"
	BDEPEND=">=${CATEGORY}/binutils-2.30[cet(-)?]"
fi

src_prepare() {
	local p upstreamed_patches=(
		# add them here
	)
	for p in "${upstreamed_patches[@]}"; do
		rm -v "${WORKDIR}/patch/${p}" || die
	done

	toolchain_src_prepare

	eapply_user
}
