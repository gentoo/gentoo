# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PATCH_GCC_VER="9.3.0" # reuse subset of patches for latest for live ebuilds gcc
PATCH_VER="2"

inherit toolchain

# Don't keyword live ebuilds
#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86"

RDEPEND=""
DEPEND="${CATEGORY}/binutils"

src_prepare() {
	local p ignore_patches=(
		11_all_extra-options.patch # needs a port
		27_all_default_ssp-buffer-size.patch # needs a port

		12_all_pr55930-dependency-tracking.patch # upstreamed
		25_all_ia64-bootstrap.patch # upstreamed
	)
	for p in "${ignore_patches[@]}"; do
		mv -v "${WORKDIR}"/patch/"${p}" "${WORKDIR}"/patch/"${p}"_disabled || die "failed to disable '${p}'"
	done

	toolchain_src_prepare
}
