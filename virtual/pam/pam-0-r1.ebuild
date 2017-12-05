# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit multilib-build

DESCRIPTION="Virtual for PAM (Pluggable Authentication Modules)"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"

RDEPEND="
	|| (
		>=sys-libs/pam-1.1.6-r2[${MULTILIB_USEDEP}]
		>=sys-auth/openpam-20120526-r1[${MULTILIB_USEDEP}]
	)"
