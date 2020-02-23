# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PATCH_GCC_VER="9.2.0" # reuse subset of patches for latest for live ebuilds gcc
PATCH_VER="4"

inherit toolchain

# Don't keyword live ebuilds
#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86"

# No gcc-10 branch yet
EGIT_BRANCH=master

RDEPEND=""
DEPEND="${RDEPEND}
	elibc_glibc? ( >=sys-libs/glibc-2.13 )
	>=${CATEGORY}/binutils-2.20"

if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.13 )"
fi

src_prepare() {
	local p ignore_patches=(
		04_all_default-ssp-fix.patch # needs a port
		11_all_extra-options.patch # needs a port
		15_all_disable-systemtap-switch.patch # needs a port

		12_all_pr55930-dependency-tracking.patch # upstreamed
		25_all_ia64-bootstrap.patch # upstreamed
		27_all_sparc-PIC-constant-PR91472.patch # upstreamed
		28_all_sparc-fpu-subregs-91269.patch # upstreamed
		29_all_mips_split_move-SEGV.patch # upstreamed
		30_all_arm64-march-native.patch # upstreamed
		31_all_openmp-for-SEGV.patch # upstreamed
		32_all_sparc-PIC-constant-part2.patch # upstreamed
		33_all_extend-lifetime.patch # upstreamed
	)
	for p in "${ignore_patches[@]}"; do
		rm "${WORKDIR}"/patch/"${p}" || die "failed to delete '${p}'"
	done

	toolchain_src_prepare
}
