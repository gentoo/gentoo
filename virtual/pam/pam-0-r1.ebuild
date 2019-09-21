# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-build

DESCRIPTION="Virtual for PAM (Pluggable Authentication Modules)"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"

RDEPEND="
	|| (
		>=sys-libs/pam-1.1.6-r2[${MULTILIB_USEDEP}]
		>=sys-auth/openpam-20120526-r1[${MULTILIB_USEDEP}]
	)"
