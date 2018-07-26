# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PATCH_GCC_VER="8.1.0"
PATCH_VER="1.3"
#UCLIBC_VER="1.0"

inherit toolchain

#needs minimal test before unkeywording
#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"

RDEPEND=""
DEPEND="${RDEPEND}
	elibc_glibc? ( >=sys-libs/glibc-2.13 )
	>=${CATEGORY}/binutils-2.20"

if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.13 )"
fi

src_prepare() {
	# upstreamed patches since 8.1.0
	EPATCH_EXCLUDE+=" 93_all_arm-arch.patch 96_all_lto-O2-PR85655.patch"

	toolchain_src_prepare
}
