# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

TOOLCHAIN_PATCH_DEV="sam"
PATCH_VER="9"
PATCH_GCC_VER="12.1.0"
MUSL_VER="6"
MUSL_GCC_VER="12.1.0"

inherit toolchain

# Don't keyword live ebuilds
#if ! tc_is_live && [[ -z ${TOOLCHAIN_USE_GIT_PATCHES} ]] ; then
#	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
#fi

# Technically only if USE=hardened *too* right now, but no point in complicating it further.
# If GCC is enabling CET by default, we need glibc to be built with support for it.
# bug #830454
RDEPEND="elibc_glibc? ( sys-libs/glibc[cet(-)?] )"
DEPEND="${RDEPEND}"
BDEPEND=">=${CATEGORY}/binutils-2.30[cet(-)?]"

src_prepare() {
	toolchain_src_prepare

	eapply_user
}
