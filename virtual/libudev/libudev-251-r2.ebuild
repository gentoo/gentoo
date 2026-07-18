# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-build

DESCRIPTION="Virtual for libudev providers"

SLOT="0/1"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="systemd static-libs"

RDEPEND="
	!systemd? ( >=sys-apps/systemd-utils-251[static-libs,udev,${MULTILIB_USEDEP}] )
	systemd? ( >=sys-apps/systemd-251:0/2[static-libs,${MULTILIB_USEDEP}] )
"
