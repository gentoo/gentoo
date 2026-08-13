# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-build

DESCRIPTION="Virtual for acl support (sys/acl.h)"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="static-libs"

RDEPEND="kernel_linux? ( >=sys-apps/acl-2.4.0[static-libs?,${MULTILIB_USEDEP}] )"
