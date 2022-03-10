# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

TOOLCHAIN_GCC_PV=12.0.1

PATCH_VER="3"
PATCH_GCC_VER="12.0.0"
MUSL_VER="1"
MUSL_GCC_VER="11.2.0"

inherit toolchain
# Needs to be after inherit (for now?), bug #830908
EGIT_BRANCH=master

# Don't keyword live ebuilds
#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86"

# Technically only if USE=hardened *too* right now, but no point in complicating it further.
# If GCC is enabling CET by default, we need glibc to be built with support for it.
# bug #830454
RDEPEND="elibc_glibc? ( sys-libs/glibc[cet(-)?] )"
DEPEND="${RDEPEND}"
BDEPEND="${CATEGORY}/binutils[cet(-)?]"

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
