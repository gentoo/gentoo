# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PATCH_GCC_VER="9.3.0" # reuse subset of patches for latest for live ebuilds gcc
PATCH_VER="1"

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

		12_all_pr55930-dependency-tracking.patch # upstreamed
		25_all_ia64-bootstrap.patch # upstreamed
	)
	for p in "${ignore_patches[@]}"; do
		mv -v "${WORKDIR}"/patch/"${p}" "${WORKDIR}"/patch/"${p}"_disabled || die "failed to disable '${p}'"
	done

	toolchain_src_prepare
}
