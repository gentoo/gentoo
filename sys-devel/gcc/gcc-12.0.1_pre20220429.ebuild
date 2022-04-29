# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PATCH_VER="5"
PATCH_GCC_VER="12.0.0"
MUSL_VER="4"
MUSL_GCC_VER="12.0.0"

# Cheesy hack for RCs
MY_PV=$(ver_cut 1).$((($(ver_cut 2) + 1))).$((($(ver_cut 3) - 1)))-RC-$(ver_cut 5)
MY_P=${PN}-${MY_PV}
GCC_TARBALL_SRC_URI="https://gcc.gnu.org/pub/gcc/snapshots/${MY_PV}/${MY_P}.tar.xz"
TOOLCHAIN_SET_S=no
S="${WORKDIR}"/${MY_P}

inherit toolchain

#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
KEYWORDS="~loong"

# Technically only if USE=hardened *too* right now, but no point in complicating it further.
# If GCC is enabling CET by default, we need glibc to be built with support for it.
# bug #830454
RDEPEND="elibc_glibc? ( sys-libs/glibc[cet(-)?] )"
DEPEND="${RDEPEND}"
BDEPEND="${CATEGORY}/binutils[cet(-)?]"

src_prepare() {
	toolchain_src_prepare

	if tc-is-cross-compiler ; then
		# bug #803371
		eapply "${FILESDIR}"/gcc-11.2.0-cross-compile-include.patch
	fi

	eapply_user
}
