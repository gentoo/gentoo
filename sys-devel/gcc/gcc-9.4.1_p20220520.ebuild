# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PATCH_GCC_VER="9.4.0"
PATCH_VER="1"
MUSL_VER="1"

# Cheesy hack for RCs
MY_PV=$(ver_cut 1).$((($(ver_cut 2) + 1))).$((($(ver_cut 3) - 1)))-RC-$(ver_cut 5)
MY_P=${PN}-${MY_PV}
GCC_TARBALL_SRC_URI="https://gcc.gnu.org/pub/gcc/snapshots/${MY_PV}/${MY_P}.tar.xz"
TOOLCHAIN_SET_S=no
S="${WORKDIR}"/${MY_P}

inherit toolchain

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND=""
DEPEND="${RDEPEND}
	elibc_glibc? ( >=sys-libs/glibc-2.13 )
	>=${CATEGORY}/binutils-2.20"

if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.13 )"
fi
