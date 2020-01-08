# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit multilib-build

DESCRIPTION="Virtual for libudev providers"
SLOT="0/1"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE="systemd"

RDEPEND="
	!systemd? ( >=sys-fs/udev-232:0/0[${MULTILIB_USEDEP}] )
	systemd? ( >=sys-apps/systemd-232:0/2[${MULTILIB_USEDEP}] )
"
