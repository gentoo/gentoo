# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PATCH_VER="1.1"

inherit toolchain

KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86"

RDEPEND=""
DEPEND="${RDEPEND}
	elibc_glibc? ( >=sys-libs/glibc-2.13 )
	>=${CATEGORY}/binutils-2.20"

if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.13 )"
fi

src_prepare() {
	toolchain_src_prepare
	eapply "${FILESDIR}"/gcc-8.3.0-ia64-bootstrap.patch
	eapply "${FILESDIR}"/gcc-8.3.0-norisc32.patch
}
