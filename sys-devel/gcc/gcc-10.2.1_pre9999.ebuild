# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PATCH_GCC_VER="10.2.0" # reuse subset of patches for latest for live ebuilds gcc
PATCH_VER="2"

inherit toolchain

# Don't keyword live ebuilds
#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86"

RDEPEND=""
BDEPEND="${CATEGORY}/binutils"

src_prepare() {
	local p upstreamed_patches=(
		32_all_sparc_pie_TEXTREL.patch
		33_all_lto-O0-mix-ICE-ipa-PR96291.patch
		35_all_ipa-fix-bit-CP.patch
		36_all_ipa-fix-bit-CP-p2.patch
	)

	for p in "${upstreamed_patches[@]}"; do
		rm -v "${WORKDIR}/patch/${p}" || die
	done

	has_version '>=sys-libs/glibc-2.32-r1' && rm -v "${WORKDIR}/patch/23_all_disable-riscv32-ABIs.patch"

	toolchain_src_prepare
}
